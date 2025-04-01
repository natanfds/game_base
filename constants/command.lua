command_constants = {
  maxTime = 2,
  bufferSize = 10,
  patterns = {
    quarterCircleFoward = "236",
    reverseQuarterCircleFoward = "632",
    quarterCircleBack = "214",
    reverseQuarterCircleBack = "412",
    halfCircleFoward = "41236",
    halfCircleBack = "63214",
    fullCircleClockwise = "632147896",
    reverseFullCircleClockwise = "478963214",
    fullCircleCounterclockwise = "698741236",
    reverseFullCircleCounterclockwise = "412369874",
    backFoward = "456",
    fowardBack = "654",
    downUp = "258"
  },
  dpad_buttons = {'dpup', 'dpdown', 'dpleft', 'dpright'},
  action_buttons = {'a', 'b', 'x', 'y', 'leftshoulder', 'rightshoulder'},
  dpad_diagonals = {
    left_up = 'dpup,dpleft,dpleft,dpup',
    right_up = 'dpup,dpright,dpright,dpup,',
    left_down = 'dpdown,dpleft,dpleft,dpdown',
    right_down = 'dpdown,dpright,dpright,dpdown'
  }
}


return command_constants