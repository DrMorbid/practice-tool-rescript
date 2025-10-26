package click.practice_tool.mcp.model;

import java.time.Instant;

/**
 * Represents an exercise practiced in a session.
 * This model is used to return historical practice data from DynamoDB.
 */
public record HistoryExercise(
                String name,
                String projectName,
                String tempo,
                Instant date) {
}
