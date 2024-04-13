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
              name: "My Project",
              active: false,
              exercises: [
                {
                  name: "Exercise 1",
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
          name: "My Project",
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
            project: {userId: "abc", name: "My Project", active: true, exercises: []},
            exerciseCount: 2,
          }),
        )->toEqual({
          name: "My Project",
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
              name: "My Project",
              active: true,
              exercises: [
                {
                  name: "Exercise 1",
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
          name: "My Project",
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
              name: "My Project",
              active: true,
              exercises: [
                {
                  name: "Exercise 1",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                },
                {
                  name: "Exercise 2",
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
          name: "My Project",
          exercises: list{},
          topPriorityExercises: list{},
        })
      },
    )

    test(
      "Given project has 1 active exercise and 1 active top priority exercise, when I request 2 exercises, then it returns only the one top priority exercise to practice",
      () => {
        expect(
          Session.Utils.createSession({
            project: {
              userId: "abc",
              name: "My Project",
              active: true,
              exercises: [
                {
                  name: "Exercise 1",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                },
                {
                  name: "Exercise 2",
                  active: true,
                  topPriority: true,
                  slowTempo: 75,
                  fastTempo: 100,
                },
              ],
            },
            exerciseCount: 2,
          }),
        )->toEqual({
          name: "My Project",
          exercises: list{},
          topPriorityExercises: list{{name: "Exercise 2", tempo: Slow, tempoValue: 75}},
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
              name: "My Project",
              active: true,
              exercises: [
                {
                  name: "Exercise 1",
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
                  name: "Exercise 2",
                  active: true,
                  topPriority: false,
                  slowTempo: 50,
                  fastTempo: 75,
                },
                {
                  name: "Exercise 3",
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
                  name: "Exercise 4",
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
                  name: "Exercise 5",
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
                  name: "Exercise 6",
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
          name: "My Project",
          exercises: list{
            {name: "Exercise 2", tempo: Slow, tempoValue: 50},
            {name: "Exercise 1", tempo: Fast, tempoValue: 100},
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
              name: "My Project",
              active: true,
              exercises: [
                {
                  name: "Exercise 1",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                },
                {
                  name: "Exercise 2",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                },
                {
                  name: "Exercise 3",
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
          name: "My Project",
          exercises: list{
            {name: "Exercise 1", tempo: Slow, tempoValue: 75},
            {name: "Exercise 2", tempo: Fast, tempoValue: 100},
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
              name: "My Project",
              active: true,
              exercises: [
                {
                  name: "Exercise 1",
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
                  name: "Exercise 2",
                  active: true,
                  topPriority: false,
                  slowTempo: 50,
                  fastTempo: 75,
                },
                {
                  name: "Exercise 3",
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
                  name: "Exercise 4",
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
                  name: "Exercise 5",
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
                  name: "Exercise 6",
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
          name: "My Project",
          exercises: list{
            {name: "Exercise 2", tempo: Slow, tempoValue: 50},
            {name: "Exercise 1", tempo: Fast, tempoValue: 100},
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
              name: "My Project",
              active: true,
              exercises: [
                {
                  name: "Exercise 1",
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
                  name: "Exercise 2",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 75,
                },
                {
                  name: "Exercise 3",
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
                  name: "Exercise 4",
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
                  name: "Exercise 5",
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
                  name: "Exercise 6",
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
          name: "My Project",
          exercises: list{
            {name: "Exercise 2", tempo: Slow, tempoValue: 75},
            {name: "Exercise 6", tempo: Fast, tempoValue: 100},
            {name: "Exercise 1", tempo: Slow, tempoValue: 75},
            {name: "Exercise 4", tempo: Fast, tempoValue: 75},
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
              name: "My Project",
              active: true,
              exercises: [
                {
                  name: "Exercise 1",
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
                  name: "Exercise 2",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 75,
                },
                {
                  name: "Exercise 3",
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
                  name: "Exercise 4",
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
                  name: "Exercise 5",
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
                  name: "Exercise 6",
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
          name: "My Project",
          exercises: list{
            {name: "Exercise 2", tempo: Slow, tempoValue: 75},
            {name: "Exercise 6", tempo: Fast, tempoValue: 100},
            {name: "Exercise 1", tempo: Slow, tempoValue: 50},
            {name: "Exercise 3", tempo: Fast, tempoValue: 100},
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
              name: "My Project",
              active: true,
              exercises: [
                {
                  name: "Exercise 1",
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
                  name: "Exercise 2",
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
                  name: "Exercise 3",
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
                  name: "Exercise 4",
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
          name: "My Project",
          exercises: list{
            {name: "Exercise 3", tempo: Slow, tempoValue: 75},
            {name: "Exercise 1", tempo: Fast, tempoValue: 75},
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
              name: "My Project",
              active: true,
              exercises: [
                {
                  name: "Exercise 1",
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
                  name: "Exercise 2",
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
                  name: "Exercise 3",
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
                  name: "Exercise 4",
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
                  name: "Exercise 5",
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
          name: "My Project",
          exercises: list{
            {name: "Exercise 3", tempo: Slow, tempoValue: 75},
            {name: "Exercise 1", tempo: Fast, tempoValue: 75},
          },
          topPriorityExercises: list{{name: "Exercise 5", tempo: Fast, tempoValue: 75}},
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
              name: "My Project",
              active: true,
              exercises: [
                {
                  name: "Exercise 1",
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
                  name: "Exercise 2",
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
                  name: "Exercise 3",
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
                  name: "Exercise 4",
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
                  name: "Exercise 5",
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
                  name: "Exercise 6",
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
                  name: "Exercise 7",
                  active: false,
                  topPriority: true,
                  slowTempo: 50,
                  fastTempo: 75,
                },
                {
                  name: "Exercise 8",
                  active: true,
                  topPriority: true,
                  slowTempo: 75,
                  fastTempo: 75,
                },
                {
                  name: "Exercise 9",
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
          name: "My Project",
          exercises: list{
            {name: "Exercise 3", tempo: Slow, tempoValue: 75},
            {name: "Exercise 1", tempo: Fast, tempoValue: 75},
          },
          topPriorityExercises: list{
            {name: "Exercise 8", tempo: Slow, tempoValue: 75},
            {name: "Exercise 5", tempo: Fast, tempoValue: 75},
            {name: "Exercise 6", tempo: Slow, tempoValue: 75},
            {name: "Exercise 9", tempo: Fast, tempoValue: 100},
          },
        })
      },
    )

    test(
      "Given project has a lot of active exercises that were not practiced yet and no active top priority, when I request 2 exercises, then it returns the 2 exercises in the correct order",
      () => {
        expect(
          Session.Utils.createSession({
            project: {
              userId: "85b8cc13-ba41-42b0-bf36-77f8a84622f8",
              name: "Mindwork",
              active: true,
              exercises: [
                {
                  name: "Causality (The Reconcilliation)",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-02-23T20:43:43.000Z"),
                    tempo: Slow,
                  },
                },
                {
                  name: "Depersonalized",
                  active: false,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-02-23T20:43:43.000Z"),
                    tempo: Fast,
                  },
                },
                {
                  name: "Enter Eterea",
                  active: false,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-02-22T20:43:43.000Z"),
                    tempo: Slow,
                  },
                },
                {
                  name: "Grinding the Edges",
                  active: false,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                  lastPracticed: {
                    date: Js.Date.fromString("2024-02-22T20:43:43.000Z"),
                    tempo: Fast,
                  },
                },
                {
                  name: "Heartfelt",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                },
                {
                  name: "Heartfelt 3",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                },
                {
                  name: "Intro",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                },
                {
                  name: "Last Lie Told",
                  active: false,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                },
                {
                  name: "Mind Renewal",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                },
                {
                  name: "Party's Over (Talk Talk cover)",
                  active: true,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                },
                {
                  name: "Perceiving The Reality",
                  active: false,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                },
                {
                  name: "The Stream Of Causality",
                  active: false,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                },
                {
                  name: "Twisted Priorities",
                  active: false,
                  topPriority: false,
                  slowTempo: 75,
                  fastTempo: 100,
                },
                {
                  name: "With Faith On My Side",
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
          name: "Mindwork",
          exercises: list{
            {name: "Heartfelt", tempo: Slow, tempoValue: 75},
            {name: "Heartfelt 3", tempo: Fast, tempoValue: 100},
          },
          topPriorityExercises: list{},
        })
      },
    )
  })
})
