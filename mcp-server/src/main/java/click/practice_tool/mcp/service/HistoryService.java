package click.practice_tool.mcp.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import click.practice_tool.mcp.model.HistoryExercise;
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;
import software.amazon.awssdk.services.dynamodb.model.*;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Service for retrieving practice history from DynamoDB.
 * Provides MCP tool methods for accessing historical practice data.
 */
@Service
public class HistoryService {

    private static final Logger logger = LoggerFactory.getLogger(HistoryService.class);

    private final DynamoDbClient dynamoDbClient;

    @Value("${dynamodb.table.history:practice-tool-rescript-history-prod}")
    private String historyTableName;

    public HistoryService(DynamoDbClient dynamoDbClient) {
        this.dynamoDbClient = dynamoDbClient;
    }

    /**
     * Retrieves all exercises practiced in the past from DynamoDB history table.
     * Scans the entire table and returns a list of exercises with their details.
     *
     * @return List of HistoryExercise objects containing name, projectName, tempo,
     *         and date
     */
    @Tool(name = "get_all_practiced_exercises", description = "Get all practiced exercises")
    public List<HistoryExercise> getAllPracticedExercises() {
        logger.info("Retrieving all practiced exercises from table: {}", historyTableName);

        List<HistoryExercise> allExercises = new ArrayList<>();

        try {
            ScanRequest scanRequest = ScanRequest.builder()
                    .tableName(historyTableName)
                    .build();

            ScanResponse response = dynamoDbClient.scan(scanRequest);

            // Process all items from the scan response
            for (Map<String, AttributeValue> item : response.items()) {
                allExercises.addAll(extractExercisesFromHistoryItem(item));
            }

            // Handle pagination if there are more items
            String lastEvaluatedKey = response.lastEvaluatedKey() != null && !response.lastEvaluatedKey().isEmpty()
                    ? response.lastEvaluatedKey().toString()
                    : null;

            while (lastEvaluatedKey != null) {
                ScanRequest paginatedRequest = ScanRequest.builder()
                        .tableName(historyTableName)
                        .exclusiveStartKey(response.lastEvaluatedKey())
                        .build();

                response = dynamoDbClient.scan(paginatedRequest);

                for (Map<String, AttributeValue> item : response.items()) {
                    allExercises.addAll(extractExercisesFromHistoryItem(item));
                }

                lastEvaluatedKey = response.lastEvaluatedKey() != null && !response.lastEvaluatedKey().isEmpty()
                        ? response.lastEvaluatedKey().toString()
                        : null;
            }

            logger.info("Successfully retrieved {} exercises from history", allExercises.size());
            return allExercises;

        } catch (DynamoDbException e) {
            logger.error("Error scanning DynamoDB table {}: {}", historyTableName, e.getMessage(), e);
            throw new RuntimeException("Failed to retrieve practice history from DynamoDB", e);
        }
    }

    /**
     * Extracts individual exercises from a DynamoDB history item.
     * Each history item contains a userId, date, and an array of exercises.
     *
     * @param item DynamoDB item map
     * @return List of HistoryExercise objects extracted from the item
     */
    private List<HistoryExercise> extractExercisesFromHistoryItem(Map<String, AttributeValue> item) {
        List<HistoryExercise> exercises = new ArrayList<>();

        try {
            // Get the date from the item (stored as ISO string in DynamoDB)
            String dateString = item.containsKey("date") ? item.get("date").s() : null;
            Instant date = dateString != null ? Instant.parse(dateString) : Instant.now();

            // Get the exercises array from the item
            if (item.containsKey("exercises") && item.get("exercises").hasL()) {
                List<AttributeValue> exercisesList = item.get("exercises").l();

                for (AttributeValue exerciseAttr : exercisesList) {
                    if (exerciseAttr.hasM()) {
                        Map<String, AttributeValue> exerciseMap = exerciseAttr.m();

                        String name = exerciseMap.containsKey("name") ? exerciseMap.get("name").s() : "Unknown";
                        String projectName = exerciseMap.containsKey("projectName") ? exerciseMap.get("projectName").s()
                                : "Unknown";
                        String tempo = exerciseMap.containsKey("tempo") ? exerciseMap.get("tempo").s() : "UNKNOWN";

                        exercises.add(new HistoryExercise(name, projectName, tempo, date));
                    }
                }
            }
        } catch (Exception e) {
            logger.warn("Error extracting exercises from DynamoDB item: {}", e.getMessage(), e);
        }

        return exercises;
    }
}
