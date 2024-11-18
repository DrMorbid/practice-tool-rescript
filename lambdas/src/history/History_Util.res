open History_Type

let toHistoryResponse = historyItems => {
  let projectsMap =
    historyItems
    ->Array.flatMap(({exercises}) => exercises)
    ->Array.reduce(Map.make(), (result, {projectName}) => {
      result->Map.set(projectName, result->Map.get(projectName)->Option.getOr(0) + 1)
      result
    })
    ->Map.entries
    ->Iterator.toArray
    ->Array.map(((projectName, practiceCount)) => {
      projectName,
      practiceCount,
      byExercises: [],
    })
    ->Array.toSorted(({projectName: projectName1}, {projectName: projectName2}) =>
      projectName1->String.compare(projectName2)
    )

  projectsMap
}
