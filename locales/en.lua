local Translations = {
    error = {
        market_not_open = 'Market is closed',
        not_claimed = 'This booth has not been claimed',
        incorrect_password = 'Incorrect password',
        already_claimed = 'This booth has already been claimed',
        existing_booth = 'You already have a claimed booth',
        already_part = 'You\'re already part of this group',
        not_part = 'You\'re not part of this group',
        password_not_number = 'Password must be a number',
    },
    primary = {
        booth_claimed = 'You have claimed a booth',
        joined_booth = 'You have joined a booth',
        global_joined_booth = '%{value} joined the booth',
        left_booth = 'You left the booth',
        global_left_booth = '%{value} left the booth',
        disband_group = 'Booth disbanded',
    },
    other = {
        input_password = 'Input Booth Password',
        set_password = 'Set Booth Password',
        password = 'Password',
        change_banner = 'Change banner',
        banner_url = 'Imjur (1024x1025)',
        submit = 'Submit',
    },
    target = {
        claim_booth = 'Claim Booth',
        leave_booth = 'Leave Booth',
        join_booth = 'Join Booth',
        banner_change = 'Change Banner',
        register_inventory = 'Inventory',
        register_pickup = 'Pickup'
    }

}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
