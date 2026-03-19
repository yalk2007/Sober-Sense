import math

def bac_calculate(age: int, weight: float, gender: str, alc: float) -> float:
    """ BAC calculation function 
    
    args: 
        age - int
        weight - float (in lbs)
        gender - str
        alc - float (in oz)
    
    returns
        - float with BAC calculate

    """
    # set r value
    r = 0
    if gender == "male":
        r = 0.73
    if gender == "female":
        r = 0.66
    if gender == "other":
        r = 0.7
        
    return round([(alc*5.14) / (weight * r)], 3)