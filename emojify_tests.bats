#!/usr/bin/env bats

@test "handles an input without a single emoji ð¿" {
  result=$(./emojify "no emoji :(")
  [ "$result" = "no emoji :(" ]
}

@test "handles an input with a single emoji ð¹" {
  result=$(./emojify "an emoji :grin:")
  [ "$result" = "an emoji ð" ]
}

@test "handles an input with a lot of emojis ð»" {
  result=$(./emojify "emojis :grin::grin: :tada:yay:champagne:")
  [ "$result" = "emojis ðð ðyayð¾" ]
}

@test "handles emojis with underscores and numbers ð¯" {
  result=$(./emojify "this is perfect :100: :1st_place_medal:")
  [ "$result" = "this is perfect ð¯ ð¥" ]
}

@test "handles emojis with + and - ð" {
  result=$(./emojify "great :+1::+1::-1:")
  [ "$result" = "great ððð" ]
}

@test "handles right-hand side emojis ð" {
  result=$(./emojify ":not_an_emoji:point_right:")
  [ "$result" = ":not_an_emojið" ]
  result=$(./emojify "::::point_right:")
  [ "$result" = ":::ð" ]
}

@test "handles punctuations just after aliases" {
  result=$(./emojify "Enter the :airplane:!")
  [ "$result" = "Enter the âï¸!" ]
}

@test "ignores existing unicode emoji characters" {
  result=$(./emojify "ð leave the emojis alone!!")
  [ "$result" = "ð leave the emojis alone!!" ]
}

@test "handles multiple spaces after an emoji" {
  result=$(./emojify ":sparkles:   Three spaces")
  [ "$result" = "â¨   Three spaces" ]
  result=$(./emojify ":sparkles:     Five spaces")
  [ "$result" = "â¨     Five spaces" ]
  result=$(./emojify ":sparkles: One space")
  [ "$result" = "â¨ One space" ]
}

@test "handles the examples from the readme ð" {
  result=$(./emojify "Hey, I just :raising_hand: you, and this is :scream: , but here's my :calling: , so :telephone_receiver: me, maybe?")
  [ "$result" = "Hey, I just ð you, and this is ð± , but here's my ð² , so ð me, maybe?" ]
  result=$(./emojify "To :bee: , or not to :bee: : that is the question... To take :muscle: against a :ocean: of troubles, and by opposing, end them?")
  [ "$result" = "To ð , or not to ð : that is the question... To take ðª against a ð of troubles, and by opposing, end them?" ]
}

@test "handles the list option" {
  emojis=$(./emojify -l | grep "2nd_place_medal")
  [ "$emojis" == ":2nd_place_medal: ð¥" ]
  emojis=$(./emojify --list | grep "2nd_place_medal")
  [ "$emojis" == ":2nd_place_medal: ð¥" ]
}

@test "handles the version option" {
  version=$(./emojify -v)
  [[ "$version" =~ ^[0-9]+.[0-9]+.[0-9]+$ ]]
  version=$(./emojify --version)
  [[ "$version" =~ ^[0-9]+.[0-9]+.[0-9]+$ ]]
}
