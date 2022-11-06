local Translations = {
    error = {
        market_not_open = 'Market is closed',
        not_claimed = 'This booth has not been claimed',
        incorrect_password = 'Incorrect password',
        already_claimed = 'This booth has already been claimed',
        existing_booth = 'You already have a claimed booth',
        already_part = 'You\'re already part of this group',
        not_part = 'You\'re not part of this group',
    },
    primary = {
        booth_claimed = 'You have claimed a booth',
        joined_booth = 'You have joined a booth',
        global_joined_booth = '%{value} joined the booth',
        left_booth = 'You left the booth',
        global_left_booth = '%{value} left the booth',
        disband_group = 'Booth disbanded',
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
