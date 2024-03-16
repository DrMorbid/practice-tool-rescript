open Jest
open Expect

describe("Session Utilities", () => {
  describe("Create Session function", () => {
    test(
      "Given project is not active, when I request 2 exercises, then it returns no exercises to practice",
      () => {
        expect(
          Session.Utils.createSession({
            project: {
              userId: "abc",
              projectName: "My Project",
              active: false,
              exercises: [
                {
                  exerciseName: "Exercise 1",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                },
              ],
            },
            exerciseCount: 2,
          }),
        )->toEqual({
          projectName: "My Project",
          exercises: list{},
          topPriorityExercises: list{},
        })
      },
    )

    test(
      "Given project has no exercises, when I request 2 exercises, then it returns no exercises to practice",
      () => {
        expect(
          Session.Utils.createSession({
            project: {userId: "abc", projectName: "My Project", active: true, exercises: []},
            exerciseCount: 2,
          }),
        )->toEqual({
          projectName: "My Project",
          exercises: list{},
          topPriorityExercises: list{},
        })
      },
    )

    test(
      "Given project has no active exercises, when I request 2 exercises, then it returns no exercises to practice",
      () => {
        expect(
          Session.Utils.createSession({
            project: {
              userId: "abc",
              projectName: "My Project",
              active: true,
              exercises: [
                {
                  exerciseName: "Exercise 1",
                  active: false,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                },
              ],
            },
            exerciseCount: 2,
          }),
        )->toEqual({
          projectName: "My Project",
          exercises: list{},
          topPriorityExercises: list{},
        })
      },
    )

    test(
      "Given project has 2 active exercises, when I request 0 exercises, then it returns no exercises to practice",
      () => {
        expect(
          Session.Utils.createSession({
            project: {
              userId: "abc",
              projectName: "My Project",
              active: true,
              exercises: [
                {
                  exerciseName: "Exercise 1",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                },
                {
                  exerciseName: "Exercise 2",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                },
              ],
            },
            exerciseCount: 0,
          }),
        )->toEqual({
          projectName: "My Project",
          exercises: list{},
          topPriorityExercises: list{},
        })
      },
    )

    test(
      "Given project has 2 active exercises, when I request 2 exercises, then it returns 2 exercises to practice",
      () => {
        expect(
          Session.Utils.createSession({
            project: {
              userId: "abc",
              projectName: "My Project",
              active: true,
              exercises: [
                {
                  exerciseName: "Exercise 1",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                },
                {
                  exerciseName: "Exercise 2",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                },
              ],
            },
            exerciseCount: 2,
          }),
        )->toEqual({
          projectName: "My Project",
          exercises: list{
            {exerciseName: "Exercise 1", tempo: Slow, tempoValue: 75},
            {exerciseName: "Exercise 2", tempo: Fast, tempoValue: 100},
          },
          topPriorityExercises: list{},
        })
      },
    )
  })
})
