open Jest
open Expect

describe("Session Utilities", () => {
  describe("Convert to Save Session Wrapper function", () => {
    test(
      "Given the input history item is in error state, when I convert it to DB items to be saved, then it returns the same error state",
      () => {
        expect(
          Error("Something went wrong")->Session.Util.toSaveSessionWrapper(~userId="123"),
        )->toEqual(Error("Something went wrong"))
      },
    )

    test(
      "Given the input history item has no exercises, when I convert it to DB items to be saved, then it returns DB items with no project and exercisse",
      () => {
        expect(
          Ok({
            userId: "123",
            date: Date.fromString("2024-05-11T11:18:00.00Z"),
            exercises: [],
          })->Session.Util.toSaveSessionWrapper(~userId="123"),
        )->toEqual(
          Ok({
            projects: {userId: "123", projects: []},
            historyItem: {
              userId: "123",
              date: Date.fromString("2024-05-11T11:18:00.00Z"),
              exercises: [],
            },
          }),
        )
      },
    )

    test(
      "Given the input history item has two exercises from one project, when I convert it to DB items to be saved, then it returns correct DB items to be saved",
      () => {
        expect(
          Ok({
            userId: "123",
            date: Date.fromString("2024-05-11T11:18:00.00Z"),
            exercises: [
              {name: "Mind Renewal", projectName: "Mindwork", tempo: Slow},
              {name: "Depersonalized", projectName: "Mindwork", tempo: Fast},
            ],
          })->Session.Util.toSaveSessionWrapper(~userId="123"),
        )->toEqual(
          Ok({
            projects: {
              userId: "123",
              projects: [
                {
                  name: "Mindwork",
                  exercises: [
                    {
                      name: "Mind Renewal",
                      lastPracticed: {
                        date: Date.fromString("2024-05-11T11:18:00.00Z"),
                        tempo: Slow,
                      },
                    },
                    {
                      name: "Depersonalized",
                      lastPracticed: {
                        date: Date.fromString("2024-05-11T11:18:00.00Z"),
                        tempo: Fast,
                      },
                    },
                  ],
                },
              ],
            },
            historyItem: {
              userId: "123",
              date: Date.fromString("2024-05-11T11:18:00.00Z"),
              exercises: [
                {name: "Mind Renewal", projectName: "Mindwork", tempo: Slow},
                {name: "Depersonalized", projectName: "Mindwork", tempo: Fast},
              ],
            },
          }),
        )
      },
    )

    test(
      "Given the input history item has two exercises from one project, when I convert it to DB items to be saved, then it returns correct DB items to be saved",
      () => {
        expect(
          Ok({
            userId: "123",
            date: Date.fromString("2024-05-11T11:18:00.00Z"),
            exercises: [
              {name: "Mind Renewal", projectName: "Mindwork", tempo: Slow},
              {name: "Depersonalized", projectName: "Mindwork", tempo: Fast},
            ],
          })->Session.Util.toSaveSessionWrapper(~userId="123"),
        )->toEqual(
          Ok({
            projects: {
              userId: "123",
              projects: [
                {
                  name: "Mindwork",
                  exercises: [
                    {
                      name: "Mind Renewal",
                      lastPracticed: {
                        date: Date.fromString("2024-05-11T11:18:00.00Z"),
                        tempo: Slow,
                      },
                    },
                    {
                      name: "Depersonalized",
                      lastPracticed: {
                        date: Date.fromString("2024-05-11T11:18:00.00Z"),
                        tempo: Fast,
                      },
                    },
                  ],
                },
              ],
            },
            historyItem: {
              userId: "123",
              date: Date.fromString("2024-05-11T11:18:00.00Z"),
              exercises: [
                {name: "Mind Renewal", projectName: "Mindwork", tempo: Slow},
                {name: "Depersonalized", projectName: "Mindwork", tempo: Fast},
              ],
            },
          }),
        )
      },
    )
  })
})
