//
//  SolarMath.swift
//  SolarNOAA
//
//  Created by Dmitry Medyuho on 8/20/18.
//  Copyright © 2018 Dmitry Medyuho. All rights reserved.
//

import Foundation

struct SolarMath {
    /// Julian day from calendar day
    ///
    /// - Parameters:
    ///   - year: 4 digit year
    ///   - month: January = 1
    ///   - day: 1 - 31
    /// - Returns: The Julian day corresponding to the date
    /// - Note:
    ///   Number is returned for start of day.  Fractional days should be added later.
    static func calcJD(year: Int, month: Int, day: Int) -> Double {
        var a: Double = 0.0, b: Double = 0.0, jd: Double = 0.0, y: Int = year, m: Int = month
        
        if m <= 2 {
            y -= 1
            m += 12
        }
        
        a = (Double(y)/100.0).rounded(.down)
        b = 2 - a + (a/4).rounded(.down)
        jd = (365.25 * Double(y + 4716)).rounded(.down) + (30.6001 * Double(m + 1)).rounded(.down) + Double(day) + b - 1524.5
        
        return jd
    }
    
    /// Convert Julian Day to centuries since J2000.0.
    ///
    /// - Parameter jd: the Julian Day to convert
    /// - Returns: the T value corresponding to the Julian Day
    static func calcTimeJulianCent(_ jd: Double) -> Double {
        return (jd - 2451545.0) / 36525.0
    }
    
    /// Calculate the Geometric Mean Anomaly of the Sun
    ///
    /// - Parameter t: number of Julian centuries since J2000.0
    /// - Returns: the Geometric Mean Anomaly of the Sun in degrees
    static func calcGeomMeanAnomalySun(_ t: Double) -> Double {
        return 357.52911 + t * (35999.05029 - 0.0001537 * t)
    }
    
    /// Calculate the equation of center for the sun
    ///
    /// - Parameter t: number of Julian centuries since J2000.0
    /// - Returns: in degrees
    static func calcSunEqOfCenter(_ t: Double) -> Double {
        var m: Double = 0.0, mrad: Double = 0.0, sinm: Double = 0.0, sin2m: Double = 0.0, sin3m: Double = 0.0
        
        m = calcGeomMeanAnomalySun(t)
        mrad = m.degToRad
        sinm = sin(mrad)
        sin2m = sin(mrad + mrad)
        sin3m = sin(mrad + mrad + mrad)
        
        return sinm * (1.914602 - t * (0.004817 + 1.4E-05 * t)) + sin2m * (0.019993 - 0.000101 * t) + sin3m * 0.000289
    }
    
    /// Calculate the eccentricity of earth's orbit
    ///
    /// - Parameter t: number of Julian centuries since J2000.0
    /// - Returns: the unitless eccentricity
    static func calcEccentricityEarthOrbit(_ t: Double) -> Double {
        return 0.016708634 - t * (4.2037E-05 + 1.267E-07 * t)
    }
    
    /// Calculate the true anamoly of the sun
    ///
    /// - Parameter t: number of Julian centuries since J2000.0
    /// - Returns: sun's true anamoly in degrees
    static func calcSunTrueAnomaly(_ t: Double) -> Double {
        return calcGeomMeanAnomalySun(t) + calcSunEqOfCenter(t)
    }
    
    /// Calculate the distance to the sun in AU
    ///
    /// - Parameter t: number of Julian centuries since J2000.0
    /// - Returns: sun radius vector in AUs
    static func calcSunRadVector(_ t: Double) -> Double {
        var v: Double = 0.0, e: Double = 0.0
        
        v = calcSunTrueAnomaly(t)
        e = calcEccentricityEarthOrbit(t)
        
        return (1.000001018 * (1 - e * e)) / (1 + e * cos(v.degToRad))
    }
    
    /// Calculate the mean obliquity of the ecliptic
    ///
    /// - Parameter t: number of Julian centuries since J2000.0
    /// - Returns: mean obliquity in degrees
    static func calcMeanObliquityOfEcliptic(_ t: Double) -> Double {
        var seconds: Double = 0.0, e0: Double = 0.0
        
        seconds = 21.448 - t * (46.815 + t * (0.00059 - t * (0.001813)))
        e0 = 23.0 + (26.0 + (seconds / 60.0)) / 60.0
        
        return e0
    }
    
    /// Calculate the corrected obliquity of the ecliptic
    ///
    /// - Parameter t: number of Julian centuries since J2000.0
    /// - Returns: corrected obliquity in degrees
    static func calcObliquityCorrection(_ t: Double) -> Double {
        var e0: Double = 0.0, omega: Double = 0.0
        
        e0 = calcMeanObliquityOfEcliptic(t)
        omega = 125.04 - 1934.136 * t
        
        return e0 + 0.00256 * cos(omega.degToRad)
    }
    
    /// Calculate the Geometric Mean Longitude of the Sun
    ///
    /// - Parameter t: number of Julian centuries since J2000.0
    /// - Returns: the Geometric Mean Longitude of the Sun in degrees
    static func calcGeomMeanLongSun(_ t: Double) -> Double {
        var l0: Double = 0.0
        
        l0 = 280.46646 + t * (36000.76983 + 0.0003032 * t)
        
        while l0 > 360.0 {
            l0 -= 360.0
        }
        
        while l0 < 0.0 {
            l0 += 360.0;
        }
        
        return l0
    }
    
    /// Calculate the true longitude of the sun
    ///
    /// - Parameter t: number of Julian centuries since J2000.0
    /// - Returns: sun's true longitude in degrees
    static func calcSunTrueLong(_ t: Double) -> Double {
        return calcGeomMeanLongSun(t) + calcSunEqOfCenter(t)
    }
    
    /// Calculate the apparent longitude of the sun
    ///
    /// - Parameter t: number of Julian centuries since J2000.0
    /// - Returns: sun's apparent longitude in degrees
    static func calcSunApparentLong(_ t: Double) -> Double {
        var o: Double = 0.0, omega: Double = 0.0
        
        o = calcSunTrueLong(t)
        omega = 125.04 - 1934.136 * t
        
        return o - 0.00569 - 0.00478 * sin(omega.degToRad)
    }
    
    /// Calculate the right ascension of the sun
    ///
    /// - Parameter t: number of Julian centuries since J2000.0
    /// - Returns: sun's right ascension in degrees
    static func calcSunRtAscension(_ t: Double) -> Double {
        var e: Double = 0.0, lambda: Double = 0.0, tananum: Double = 0.0, tanadenom: Double = 0.0
        
        e = calcObliquityCorrection(t)
        lambda = calcSunApparentLong(t)
        
        tananum = cos(e.degToRad) * sin(lambda.degToRad)
        tanadenom = cos(lambda.degToRad)
        
        return atan2(tanadenom, tananum).radToDeg
    }
    
    /// Calculate the declination of the sun
    ///
    /// - Parameter t: number of Julian centuries since J2000.0
    /// - Returns: sun's declination in degrees
    static func calcSunDeclination(_ t: Double) -> Double {
        var e: Double = 0.0, lambda: Double = 0.0, sint: Double = 0.0
        
        e = calcObliquityCorrection(t)
        lambda = calcSunApparentLong(t)
        
        sint = sin(e.degToRad) * sin(lambda.degToRad)
        
        return asin(sint).radToDeg
    }
    
    /// Calculate the difference between true solar time and mean solar time
    ///
    /// - Parameter t: number of Julian centuries since J2000.0
    /// - Returns: equation of time in minutes of time
    static func calcEquationOfTime(_ t: Double) -> Double {
        var epsilon: Double = 0.0, l0: Double = 0.0, e: Double = 0.0, m: Double = 0.0
        var y: Double = 0.0, sin2l0: Double = 0.0, sinm: Double = 0.0
        var cos2l0: Double = 0.0, sin4l0: Double = 0.0, sin2m: Double = 0.0, eTime: Double = 0.0
        
        epsilon = calcObliquityCorrection(t)
        l0 = calcGeomMeanLongSun(t)
        e = calcEccentricityEarthOrbit(t)
        m = calcGeomMeanAnomalySun(t)
        
        y = tan(epsilon.degToRad / 2.0)
        y = pow(y, 2)
        
        sin2l0 = sin(2.0 * l0.degToRad)
        sinm = sin(m.degToRad)
        cos2l0 = cos(2.0 * l0.degToRad)
        sin4l0 = sin(4.0 * l0.degToRad)
        sin2m = sin(2.0 * m.degToRad)
        
        eTime = y * sin2l0 - 2.0 * e * sinm + 4.0 * e * y * sinm * cos2l0 - 0.5 * y * y * sin4l0 - 1.25 * e * e * sin2m
        
        return eTime.radToDeg * 4.0
    }
    
    /// Calculate the hour angle of the sun at dawn for the latitude
    /// for user selected solar depression below horizon
    ///
    /// - Parameters:
    ///   - lat: latitude of observer in degrees
    ///   - solarDec: declination angle of sun in degrees
    ///   - solardepression: angle of the sun below the horizion in degrees
    /// - Returns: hour angle of dawn in radians
    static func calcHourAngleDawn(lat: Double, solarDec: Double, solardepression: Double) -> Double {
        var latRad: Double = 0.0, sdRad: Double = 0.0
        
        latRad = lat.degToRad
        sdRad = solarDec.degToRad
        
        return acos(cos((90 + solardepression).degToRad) / (cos(latRad) * cos(sdRad)) - tan(latRad) * tan(sdRad))
    }
    
    /// Calculate the hour angle of the sun at sunrise for the latitude
    ///
    /// - Parameters:
    ///   - lat: latitude of observer in degrees
    ///   - solarDec: declination angle of sun in degrees
    /// - Returns: hour angle of sunrise in radians
    static func calcHourAngleSunrise(lat: Double, solarDec: Double) -> Double {
        var latRad: Double = 0.0, sdRad: Double = 0.0
        
        latRad = lat.degToRad
        sdRad = solarDec.degToRad
        
        return acos(cos(90.833.degToRad) / (cos(latRad) * cos(sdRad)) - tan(latRad) * tan(sdRad))
    }
    
    /// Calculate the hour angle of the sun at sunset for the latitude
    ///
    /// - Parameters:
    ///   - lat: latitude of observer in degrees
    ///   - solarDec: declination angle of sun in degrees
    /// - Returns: hour angle of sunset in radians
    static func calcHourAngleSunset(lat: Double, solarDec: Double) -> Double {
        return -calcHourAngleSunrise(lat: lat, solarDec: solarDec)
    }
    
    /// Calculate the hour angle of the sun at dusk for the latitude
    /// for user selected solar depression below horizon
    ///
    /// - Parameters:
    ///   - lat: latitude of observer in degrees
    ///   - solarDec: declination angle of sun in degrees
    ///   - solardepression: angle of sun below horizon in degrees
    /// - Returns: hour angle of dusk in radians
    static func calcHourAngleDusk(lat: Double, solarDec: Double, solardepression: Double) -> Double {
        var latRad: Double = 0.0, sdRad: Double = 0.0
        
        latRad = lat.degToRad
        sdRad = solarDec.degToRad
        
        return -acos(cos((90 + solardepression).degToRad) / (cos(latRad) * cos(sdRad)) - tan(latRad) * tan(sdRad))
    }
    
    /// Convert centuries since J2000.0 to Julian Day.
    ///
    /// - Parameter t: number of Julian centuries since J2000.0
    /// - Returns: the Julian Day corresponding to the t value
    static func calcJDFromJulianCent(_ t: Double) -> Double {
        return t * 36525.0 + 2451545.0
    }
    
    /// Calculate the Universal Coordinated Time (UTC) of dawn
    /// for the given day at the given location on earth
    /// for user selected solar depression below horizon
    ///
    /// - Parameters:
    ///   - jd: julian day
    ///   - latitude: latitude of observer in degrees
    ///   - longitude: longitude of observer in degrees
    ///   - solardepression: angle of sun below the horizon in degrees
    /// - Returns: time in minutes from zero Z
    static func calcDawnUTC(jd: Double, latitude: Double, longitude: Double, solardepression: Double) -> Double {
        var t: Double = 0.0, eqTime: Double = 0.0, solarDec: Double = 0.0, hourAngle: Double = 0.0
        var delta: Double = 0.0, timeDiff: Double = 0.0, timeUTC: Double = 0.0
        var newt: Double = 0.0
        
        t = calcTimeJulianCent(Double(jd))
        
        // First pass to approximate sunrise
        eqTime = calcEquationOfTime(t)
        solarDec = calcSunDeclination(t)
        hourAngle = calcHourAngleSunrise(lat: latitude, solarDec: solarDec)
        
        delta = longitude - hourAngle.radToDeg
        timeDiff = 4 * delta
        // in minutes of time
        timeUTC = 720 + timeDiff - eqTime
        
        // Second pass includes fractional jday in gamma calc
        newt = calcTimeJulianCent(calcJDFromJulianCent(t) + timeUTC / 1440.0)
        eqTime = calcEquationOfTime(newt)
        solarDec = calcSunDeclination(newt)
        hourAngle = calcHourAngleDawn(lat: latitude, solarDec: solarDec, solardepression: solardepression)
        delta = longitude - hourAngle.radToDeg
        timeDiff = 4 * delta
        timeUTC = 720 + timeDiff - eqTime
        
        return timeUTC
    }
    
    /// Calculate the Universal Coordinated Time (UTC) of sunrise
    /// for the given day at the given location on earth
    ///
    /// - Parameters:
    ///   - JD: julian day
    ///   - latitude: latitude of observer in degrees
    ///   - longitude: longitude of observer in degrees
    /// - Returns: time in minutes from zero Z
    static func calcSunriseUTC(JD: Double, latitude: Double, longitude: Double) -> Double {
        var t: Double = 0.0, eqTime: Double = 0.0, solarDec: Double = 0.0, hourAngle: Double = 0.0
        var delta: Double = 0.0, timeDiff: Double = 0.0, timeUTC: Double = 0.0
        var newt: Double = 0.0
        
        t = calcTimeJulianCent(JD)
        
        // First pass to approximate sunrise
        eqTime = calcEquationOfTime(t)
        solarDec = calcSunDeclination(t)
        hourAngle = calcHourAngleSunrise(lat: latitude, solarDec: solarDec)
        
        delta = longitude - hourAngle.radToDeg
        timeDiff = 4 * delta
        // in minutes of time
        timeUTC = 720 + timeDiff - eqTime
        
        // Second pass includes fractional jday in gamma calc
        newt = calcTimeJulianCent(calcJDFromJulianCent(t) + timeUTC / 1440.0)
        eqTime = calcEquationOfTime(newt)
        solarDec = calcSunDeclination(newt)
        hourAngle = calcHourAngleSunrise(lat: latitude, solarDec: solarDec)
        delta = longitude - hourAngle.radToDeg
        timeDiff = 4 * delta
        timeUTC = 720 + timeDiff - eqTime
        
        return timeUTC
    }
    
    /// Calculate the Universal Coordinated Time (UTC) of solar
    /// noon for the given day at the given location on earth
    ///
    /// - Parameters:
    ///   - t: number of Julian centuries since J2000.0
    ///   - longitude: longitude of observer in degrees
    /// - Returns: time in minutes from zero Z
    static func calcSolNoonUTC(t: Double, longitude: Double) -> Double {
        var newt: Double = 0.0, eqTime: Double = 0.0, solNoonUTC: Double = 0.0
        
        newt = calcTimeJulianCent(calcJDFromJulianCent(t) + 0.5 + longitude / 360.0)
        
        eqTime = calcEquationOfTime(newt)
        solNoonUTC = 720 + (longitude * 4) - eqTime
        
        return solNoonUTC
    }
    
    /// Calculate the Universal Coordinated Time (UTC) of sunset
    /// for the given day at the given location on earth
    ///
    /// - Parameters:
    ///   - jd: julian day
    ///   - latitude: latitude of observer in degrees
    ///   - longitude: longitude of observer in degrees
    /// - Returns: time in minutes from zero Z
    static func calcSunsetUTC(jd: Double, latitude: Double, longitude: Double) -> Double {
        var t: Double = 0.0, eqTime: Double = 0.0, solarDec: Double = 0.0, hourAngle: Double = 0.0
        var delta: Double = 0.0, timeDiff: Double = 0.0, timeUTC: Double = 0.0
        var newt: Double = 0.0
        
        t = calcTimeJulianCent(jd)
        
        // First calculates sunrise and approx length of day
        eqTime = calcEquationOfTime(t)
        solarDec = calcSunDeclination(t)
        hourAngle = calcHourAngleSunset(lat: latitude, solarDec: solarDec)
        
        delta = longitude - hourAngle.radToDeg
        timeDiff = 4 * delta
        timeUTC = 720 + timeDiff - eqTime
        
        // first pass used to include fractional day in gamma calc
        newt = calcTimeJulianCent(calcJDFromJulianCent(t) + timeUTC / 1440.0)
        eqTime = calcEquationOfTime(newt)
        solarDec = calcSunDeclination(newt)
        hourAngle = calcHourAngleSunset(lat: latitude, solarDec: solarDec)
        
        delta = longitude - hourAngle.radToDeg
        timeDiff = 4 * delta
        timeUTC = 720 + timeDiff - eqTime
        
        return timeUTC
    }
    
    /// Calculate the Universal Coordinated Time (UTC) of dusk
    /// for the given day at the given location on earth
    /// for user selected solar depression below horizon
    ///
    /// - Parameters:
    ///   - jd: julian day
    ///   - latitude: latitude of observer in degrees
    ///   - longitude: longitude of observer in degrees
    ///   - solardepression: angle of sun below horizon
    /// - Returns: time in minutes from zero Z
    static func calcDuskUTC(jd: Double, latitude: Double, longitude: Double, solardepression: Double) -> Double {
        var t: Double = 0.0, eqTime: Double = 0.0, solarDec: Double = 0.0, hourAngle: Double = 0.0
        var delta: Double = 0.0, timeDiff: Double = 0.0, timeUTC: Double = 0.0
        var newt: Double = 0.0
        
        t = calcTimeJulianCent(jd)
        
        // First calculates sunrise and approx length of day
        eqTime = calcEquationOfTime(t)
        solarDec = calcSunDeclination(t)
        hourAngle = calcHourAngleSunset(lat: latitude, solarDec: solarDec)
        
        delta = longitude - hourAngle.radToDeg
        timeDiff = 4 * delta
        timeUTC = 720 + timeDiff - eqTime
        
        // first pass used to include fractional day in gamma calc
        newt = calcTimeJulianCent(calcJDFromJulianCent(t) + timeUTC / 1440.0)
        eqTime = calcEquationOfTime(newt)
        solarDec = calcSunDeclination(newt)
        hourAngle = calcHourAngleDusk(lat: latitude, solarDec: solarDec, solardepression: solardepression)
        
        delta = longitude - hourAngle.radToDeg
        timeDiff = 4 * delta
        timeUTC = 720 + timeDiff - eqTime
        
        return timeUTC
    }
}
