# Battery-Daemon

# Charging Parameters

IF Battery Level < 20% THEN
    STOP Charging (minimum battery level not reached)
ELSE IF Battery Level > 90% THEN
    STOP Charging (maximum battery level reached, preserving battery health)
ELSE IF Battery Level == 100% THEN
    STOP Charging (avoid overcharging)

IF Temperature < 0°C THEN
    STOP Charging (temperature too low for safe charging)
ELSE IF Temperature > 35°C THEN
    STOP Charging (temperature too high for safe charging)

IF Power Source == "Unplugged" THEN
    STOP Charging (charging only allowed when plugged in)

IF System Load > 80% THEN
    SLOW Charging (reduce charging speed to avoid heat generation)
    IF System Load > 90% THEN
        PAUSE Charging (pause charging to prevent overheating)

IF Battery Health < 80% THEN
    STOP Charging at 80% (battery health too low, preserve lifespan)

# Discharging Parameters

IF Battery Level < 20% THEN
    STOP Discharging (minimum battery level reached)
ELSE IF Battery Level > 90% THEN
    STOP Discharging (maximum discharge level reached)
ELSE IF Battery Level == 10% THEN
    START Charging (battery level too low, need to charge)

IF Temperature < 0°C THEN
    STOP Discharging (temperature too low for safe discharging)
ELSE IF Temperature > 35°C THEN
    STOP Discharging (temperature too high for safe discharging)

IF System Load > 80% THEN
    SLOW Discharging (reduce discharge speed to avoid additional heat)
    IF System Load > 90% THEN
        PAUSE Discharging (pause discharging to prevent overheating)

IF Battery Health < 80% THEN
    AVOID Discharging Below 20% (to preserve battery lifespan)

# Device Usage

IF Device is Idle THEN
    NORMAL Discharging Rate (battery can discharge normally)
ELSE IF Device is Under Heavy Usage THEN
    REDUCE Discharge Rate (heavy usage increases rate of discharge, manage carefully)
