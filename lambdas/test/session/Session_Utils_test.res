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
      "Given project has 6 active exercises, when only one has never been practiced and I request odd number of exercises, then it returns exercises as if I requested n - 1",
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
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-10T21:30:54.321Z00:00"),
                    tempo: Slow,
                  },
                },
                {
                  exerciseName: "Exercise 2",
                  active: true,
                  topPriority: false,
                  slowTempo: 50,
                  fastTempo: 75,
                },
                {
                  exerciseName: "Exercise 3",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-10T21:30:54.321Z00:00"),
                    tempo: Fast,
                  },
                },
                {
                  exerciseName: "Exercise 4",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-11T21:30:54.321Z00:00"),
                    tempo: Slow,
                  },
                },
                {
                  exerciseName: "Exercise 5",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-11T21:30:54.321Z00:00"),
                    tempo: Fast,
                  },
                },
                {
                  exerciseName: "Exercise 6",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-12T21:30:54.321Z00:00"),
                    tempo: Slow,
                  },
                },
              ],
            },
            exerciseCount: 3,
          }),
        )->toEqual({
          projectName: "My Project",
          exercises: list{
            {exerciseName: "Exercise 2", tempo: Slow, tempoValue: 50},
            {exerciseName: "Exercise 1", tempo: Fast, tempoValue: 100},
          },
          topPriorityExercises: list{},
        })
      },
    )

    test(
      "Given project has 2 active exercises, when none of them has ever been practiced and I request 2 exercises, then it returns 2 exercises to practice with correct tempos",
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
                {
                  exerciseName: "Exercise 3",
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
          exercises: list{
            {exerciseName: "Exercise 1", tempo: Slow, tempoValue: 75},
            {exerciseName: "Exercise 2", tempo: Fast, tempoValue: 100},
          },
          topPriorityExercises: list{},
        })
      },
    )

    test(
      "Given project has 6 active exercises, when only one has never been practiced and I request 2 exercises, then it returns the one that has never been practiced and the oldest one from the rest",
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
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-10T21:30:54.321Z00:00"),
                    tempo: Slow,
                  },
                },
                {
                  exerciseName: "Exercise 2",
                  active: true,
                  topPriority: false,
                  slowTempo: 50,
                  fastTempo: 75,
                },
                {
                  exerciseName: "Exercise 3",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-10T21:30:54.321Z00:00"),
                    tempo: Fast,
                  },
                },
                {
                  exerciseName: "Exercise 4",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-11T21:30:54.321Z00:00"),
                    tempo: Slow,
                  },
                },
                {
                  exerciseName: "Exercise 5",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-11T21:30:54.321Z00:00"),
                    tempo: Fast,
                  },
                },
                {
                  exerciseName: "Exercise 6",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-12T21:30:54.321Z00:00"),
                    tempo: Slow,
                  },
                },
              ],
            },
            exerciseCount: 2,
          }),
        )->toEqual({
          projectName: "My Project",
          exercises: list{
            {exerciseName: "Exercise 2", tempo: Slow, tempoValue: 50},
            {exerciseName: "Exercise 1", tempo: Fast, tempoValue: 100},
          },
          topPriorityExercises: list{},
        })
      },
    )

    test(
      "Given project has 4 active exercises, when I request 6 exercises, then it returns the 4 exercises in the correct order",
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
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-10T21:30:54.321Z00:00"),
                    tempo: Fast,
                  },
                },
                {
                  exerciseName: "Exercise 2",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 75,
                },
                {
                  exerciseName: "Exercise 3",
                  active: false,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-10T21:30:54.321Z00:00"),
                    tempo: Slow,
                  },
                },
                {
                  exerciseName: "Exercise 4",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 75,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-11T21:30:54.321Z00:00"),
                    tempo: Fast,
                  },
                },
                {
                  exerciseName: "Exercise 5",
                  active: false,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-11T21:30:54.321Z00:00"),
                    tempo: Slow,
                  },
                },
                {
                  exerciseName: "Exercise 6",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                },
              ],
            },
            exerciseCount: 6,
          }),
        )->toEqual({
          projectName: "My Project",
          exercises: list{
            {exerciseName: "Exercise 2", tempo: Slow, tempoValue: 75},
            {exerciseName: "Exercise 6", tempo: Fast, tempoValue: 100},
            {exerciseName: "Exercise 1", tempo: Slow, tempoValue: 75},
            {exerciseName: "Exercise 4", tempo: Fast, tempoValue: 75},
          },
          topPriorityExercises: list{},
        })
      },
    )

    test(
      "Given project has 6 active exercises, when no exercise was practiced on the fast tempo in the past and I request 4 exercises, then it returns the 4 exercises in the correct order",
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
                  slowTempo: 50,
                  fastTempo: 75,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-10T21:30:54.321Z00:00"),
                    tempo: Slow,
                  },
                },
                {
                  exerciseName: "Exercise 2",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 75,
                },
                {
                  exerciseName: "Exercise 3",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-10T21:30:54.321Z00:00"),
                    tempo: Slow,
                  },
                },
                {
                  exerciseName: "Exercise 4",
                  active: true,
                  topPriority: false,
                  slowTempo: 50,
                  fastTempo: 75,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-11T21:30:54.321Z00:00"),
                    tempo: Slow,
                  },
                },
                {
                  exerciseName: "Exercise 5",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 75,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-11T21:30:54.321Z00:00"),
                    tempo: Slow,
                  },
                },
                {
                  exerciseName: "Exercise 6",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                },
              ],
            },
            exerciseCount: 4,
          }),
        )->toEqual({
          projectName: "My Project",
          exercises: list{
            {exerciseName: "Exercise 2", tempo: Slow, tempoValue: 75},
            {exerciseName: "Exercise 6", tempo: Fast, tempoValue: 100},
            {exerciseName: "Exercise 1", tempo: Slow, tempoValue: 50},
            {exerciseName: "Exercise 3", tempo: Fast, tempoValue: 100},
          },
          topPriorityExercises: list{},
        })
      },
    )

    test(
      "Given project has 4 active exercises, when the oldest was practiced on the slow tempo and I request 2 exercises, then it returns the 2 exercises in the correct order",
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
                  slowTempo: 50,
                  fastTempo: 75,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-10T21:30:54.321Z00:00"),
                    tempo: Slow,
                  },
                },
                {
                  exerciseName: "Exercise 2",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 75,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-11T21:30:54.321Z00:00"),
                    tempo: Slow,
                  },
                },
                {
                  exerciseName: "Exercise 3",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-11T21:30:54.321Z00:00"),
                    tempo: Fast,
                  },
                },
                {
                  exerciseName: "Exercise 4",
                  active: true,
                  topPriority: false,
                  slowTempo: 50,
                  fastTempo: 75,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-12T21:30:54.321Z00:00"),
                    tempo: Slow,
                  },
                },
              ],
            },
            exerciseCount: 2,
          }),
        )->toEqual({
          projectName: "My Project",
          exercises: list{
            {exerciseName: "Exercise 3", tempo: Slow, tempoValue: 75},
            {exerciseName: "Exercise 1", tempo: Fast, tempoValue: 75},
          },
          topPriorityExercises: list{},
        })
      },
    )

    test(
      "Given project has 4 active exercises and one active top priority, when the oldest was practiced on the slow tempo and I request 2 exercises, then it returns the 2 exercises in the correct order and the top priority exercise",
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
                  slowTempo: 50,
                  fastTempo: 75,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-10T21:30:54.321Z00:00"),
                    tempo: Slow,
                  },
                },
                {
                  exerciseName: "Exercise 2",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 75,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-11T21:30:54.321Z00:00"),
                    tempo: Slow,
                  },
                },
                {
                  exerciseName: "Exercise 3",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-11T21:30:54.321Z00:00"),
                    tempo: Fast,
                  },
                },
                {
                  exerciseName: "Exercise 4",
                  active: true,
                  topPriority: false,
                  slowTempo: 50,
                  fastTempo: 75,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-12T21:30:54.321Z00:00"),
                    tempo: Slow,
                  },
                },
                {
                  exerciseName: "Exercise 5",
                  active: true,
                  topPriority: true,
                  slowTempo: 75,
                  fastTempo: 75,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-13T21:30:54.321Z00:00"),
                    tempo: Slow,
                  },
                },
              ],
            },
            exerciseCount: 2,
          }),
        )->toEqual({
          projectName: "My Project",
          exercises: list{
            {exerciseName: "Exercise 3", tempo: Slow, tempoValue: 75},
            {exerciseName: "Exercise 1", tempo: Fast, tempoValue: 75},
          },
          topPriorityExercises: list{{exerciseName: "Exercise 5", tempo: Fast, tempoValue: 75}},
        })
      },
    )

    test(
      "Given project has 4 active exercises and more than one active top priority, when the oldest was practiced on the slow tempo and I request 2 exercises, then it returns the 2 exercises in the correct order and all the top priority exercises",
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
                  slowTempo: 50,
                  fastTempo: 75,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-10T21:30:54.321Z00:00"),
                    tempo: Slow,
                  },
                },
                {
                  exerciseName: "Exercise 2",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 75,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-11T21:30:54.321Z00:00"),
                    tempo: Slow,
                  },
                },
                {
                  exerciseName: "Exercise 3",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-11T21:30:54.321Z00:00"),
                    tempo: Fast,
                  },
                },
                {
                  exerciseName: "Exercise 4",
                  active: true,
                  topPriority: false,
                  slowTempo: 50,
                  fastTempo: 75,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-12T21:30:54.321Z00:00"),
                    tempo: Slow,
                  },
                },
                {
                  exerciseName: "Exercise 5",
                  active: true,
                  topPriority: true,
                  slowTempo: 75,
                  fastTempo: 75,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-13T21:30:54.321Z00:00"),
                    tempo: Slow,
                  },
                },
                {
                  exerciseName: "Exercise 6",
                  active: true,
                  topPriority: true,
                  slowTempo: 75,
                  fastTempo: 100,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-13T21:30:54.321Z00:00"),
                    tempo: Fast,
                  },
                },
                {
                  exerciseName: "Exercise 7",
                  active: false,
                  topPriority: true,
                  slowTempo: 50,
                  fastTempo: 75,
                },
                {
                  exerciseName: "Exercise 8",
                  active: true,
                  topPriority: true,
                  slowTempo: 75,
                  fastTempo: 75,
                },
                {
                  exerciseName: "Exercise 9",
                  active: true,
                  topPriority: true,
                  slowTempo: 75,
                  fastTempo: 100,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-03-14T21:30:54.321Z00:00"),
                    tempo: Slow,
                  },
                },
              ],
            },
            exerciseCount: 2,
          }),
        )->toEqual({
          projectName: "My Project",
          exercises: list{
            {exerciseName: "Exercise 3", tempo: Slow, tempoValue: 75},
            {exerciseName: "Exercise 1", tempo: Fast, tempoValue: 75},
          },
          topPriorityExercises: list{
            {exerciseName: "Exercise 8", tempo: Slow, tempoValue: 75},
            {exerciseName: "Exercise 5", tempo: Fast, tempoValue: 75},
            {exerciseName: "Exercise 6", tempo: Slow, tempoValue: 75},
            {exerciseName: "Exercise 9", tempo: Fast, tempoValue: 100},
          },
        })
      },
    )
  })
})
