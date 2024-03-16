open Jest
open Expect

describe("Session Utilities", () => {
  describe("Create Session function", () => {
    test(
      "Given project does not exist when I request 2 exercises then it returns nothing",
      () => {
        expect(
          Session.Utils.createSession({
            projectTableKey: {userId: "abc", projectName: "My Project"},
            exerciseCount: 2,
          }),
        )->toEqual({
          projectTableKey: {userId: "abc", projectName: "My Project"},
          exercises: list{},
          topPriorityExercises: list{},
        })
      },
    )
  })
})
