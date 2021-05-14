//
//  Solar.swift
//  Test
//
//  Created by Dmitry Medyuho on 8/20/18.
//  Copyright © 2018 rlxone. All rights reserved.
//

import Foundation

/// Calculation of local times of sunrise, solar noon, and sunset
/// based on the calculation procedure by NOAA in the javascript in
/// http://www.srrb.noaa.gov/highlights/sunrise/sunrise.html and
/// http://www.srrb.noaa.gov/highlights/sunrise/azel.html
/// - Note:
/// Five functions are available
///
///  - azimuth(lat, lon, year, month, day, hour, minute, second, timezone, dlstime)
///  - elevation(lat, lon, year, month, day, hour, minute, second, timezone, dlstime)
///  - sunrise(lat, lon, year, month, day, timezone, dlstime)
///  - sunset(lat, lon, year, month, day, timezone, dlstime)
///  - solarnoon(lat, lon, year, month, day, timezone, dlstime)
///
/// The sign convention for inputs to the functions named sunrise, solarnoon,
/// sunset, solarazimuth, and solarelevationis:
///
///   - positive latitude decimal degrees for northern hemisphere
///   - negative longitude degrees for western hemisphere
///   - negative time zone hours for western hemisphere
///
/// The other functions in the Swift use the original
/// NOAA sign convention of positive longitude in the western hemisphere.
///
/// The calculations in the NOAA Sunrise/Sunset and Solar Position
/// Calculators are based on equations from Astronomical Algorithms,
/// by Jean Meeus. NOAA also included atmospheric refraction effects.
/// The sunrise and sunset results were reported by NOAA
/// to be accurate to within +/- 1 minute for locations between +/- 72°
/// latitude, and within ten minutes outside of those latitudes.
///
/// This translation was tested for selected locations
/// and found to provide results within +/- 1 minute of the
/// original Javascript code.
///
/// This translation does not include calculation of prior or next
/// susets for locations above the Arctic Circle and below the
/// Antarctic Circle, when a sunrise or sunset does not occur.
///
/// Translated from VBA to Swift by rlxone
public struct Solar {
    /// Calculate solar azimuth (deg from north) for the entered
    /// date, time and location. Returns -999999 if darker than twilight
    ///
    /// - Parameters:
    ///   - lat: latitude (decimal degrees)
    ///   - lon: longitude (decimal degrees)
    ///   - year: year
    ///   - month: month
    ///   - day: day
    ///   - hours: hours
    ///   - minutes: minutes
    ///   - seconds: seconds
    ///   - timezone: time zone hours relative to GMT/UTC (hours)
    ///   - dlstime: daylight savings time (0 = no, 1 = yes) (hours)
    /// - Returns: solar azimuth in degrees from north
    /// - Note: longitude is negative for western hemisphere for input cells
    /// in the spreadsheet for calls to the functions named
    /// sunrise, solarnoon, and sunset. Those functions convert the
    /// longitude to positive for the western hemisphere for calls to
    /// other functions using the original sign convention
    /// from the NOAA javascript code.
    public static func azimuth(lat: Double, lon: Double,
                             year: Int, month: Int, day: Int,
                             hours: Int, minutes: Int, seconds: Int,
                             timezone: Int, dlstime: Int) -> Double {
        var longitude: Double = 0.0, latitude: Double = 0.0
        var zone: Double = 0.0, daySavings: Double = 0.0
        var hh: Double = 0.0, mm: Double = 0.0, ss: Double = 0.0, timenow: Double = 0.0
        var jd: Double = 0.0, t: Double = 0.0
        var theta: Double = 0.0, eTime: Double = 0.0, eqTime: Double = 0.0
        var solarDec: Double = 0.0, solarTimeFix: Double = 0.0
        var trueSolarTime: Double = 0.0, hourAngle: Double = 0.0, haRad: Double = 0.0
        var csz: Double = 0.0, zenith: Double = 0.0, azDenom: Double = 0.0, azRad: Double = 0.0
        var azimuth: Double = 0.0
        
        // change sign convention for longitude from negative to positive in western hemisphere
        longitude = lon * -1
        latitude = lat
        if latitude > 89.8 {
            latitude = 89.8
        }
        if latitude < -89.8 {
            latitude = -89.8
        }
        
        // change time zone to ppositive hours in western hemisphere
        zone = Double(timezone * -1)
        daySavings = Double(dlstime * 60)
        hh = Double(hours) - Double(daySavings / 60)
        mm = Double(minutes)
        ss = Double(seconds)
        
        // timenow is GMT time for calculation in hours since 0Z
        timenow = hh + mm / 60 + ss / 3600 + zone
        
        jd = SolarMath.calcJD(year: year, month: month, day: day)
        t = SolarMath.calcTimeJulianCent(jd + timenow / 24.0)
        theta = SolarMath.calcSunDeclination(t)
        eTime = SolarMath.calcEquationOfTime(t)
        
        eqTime = eTime
        solarDec = theta
        
        solarTimeFix = eqTime - 4.0 * longitude + 60.0 * zone
        trueSolarTime = hh * 60.0 + mm + ss / 60.0 + solarTimeFix
        
        while trueSolarTime > 1440 {
            trueSolarTime -= 1440
        }
        
        hourAngle = trueSolarTime / 4.0 - 180.0
        if hourAngle < -180 {
            hourAngle = hourAngle + 360.0
        }
        
        haRad = hourAngle.degToRad
        
        csz = sin(latitude.degToRad) * sin(solarDec.degToRad) +
            cos(latitude.degToRad) * cos(solarDec.degToRad) * cos(haRad)
        
        if csz > 1.0 {
            csz = 1
        } else if csz < -1.0 {
            csz = -1
        }
        
        zenith = acos(csz).radToDeg
        azDenom = cos(latitude.degToRad) * sin(zenith.degToRad)
        
        if abs(azDenom) > 0.0001 {
            azRad = ((sin(latitude.degToRad) * cos(zenith.degToRad)) -
                sin(solarDec.degToRad)) / azDenom
            if abs(azRad) > 1.0 {
                if azRad < 0 {
                    azRad = -1.0
                } else {
                    azRad = 1.0
                }
            }
            azimuth = 180.0 - acos(azRad).radToDeg
            if hourAngle > 0 {
                azimuth = -azimuth
            }
        } else {
            if latitude > 0 {
                azimuth = 180.0
            } else {
                azimuth = 0
            }
        }
        
        if azimuth < 0 {
            azimuth += 360
        }
        
        return azimuth
    }
    
    /// Calculate elevation (deg from north) for the entered
    /// date, time and location.
    ///
    /// - Parameters:
    ///   - lat: latitude (decimal degrees)
    ///   - lon: longitude (decimal degrees)
    ///   - year: year
    ///   - month: month
    ///   - day: day
    ///   - hours: hours
    ///   - minutes: minutes
    ///   - seconds: seconds
    ///   - timezone: time zone hours relative to GMT/UTC (hours)
    ///   - dlstime: daylight savings time (0 = no, 1 = yes) (hours)
    /// - Returns: solar elevation
    /// - Note: longitude is negative for western hemisphere for input cells
    /// in the spreadsheet for calls to the functions named
    /// sunrise, solarnoon, and sunset. Those functions convert the
    /// longitude to positive for the western hemisphere for calls to
    /// other functions using the original sign convention
    /// from the NOAA javascript code.
    public static func elevation(lat: Double, lon: Double,
                               year: Int, month: Int, day: Int,
                               hours: Int, minutes: Int, seconds: Int,
                               timezone: Int, dlstime: Int) -> Double {
        var longitude: Double = 0.0, latitude: Double = 0.0
        var zone: Double = 0.0, daySavings: Double = 0.0
        var hh: Double = 0.0, mm: Double = 0.0, ss: Double = 0.0, timenow: Double = 0.0
        var jd: Double = 0.0, t: Double = 0.0
        var theta: Double = 0.0, eTime: Double = 0.0, eqTime: Double = 0.0
        var solarDec: Double = 0.0, solarTimeFix: Double = 0.0
        var trueSolarTime: Double = 0.0, hourAngle: Double = 0.0, haRad: Double = 0.0
        var csz: Double = 0.0, zenith: Double = 0.0, azDenom: Double = 0.0, azRad: Double = 0.0
        var azimuth: Double = 0.0, exoatmElevation: Double = 0.0
        var refractionCorrection: Double = 0.0, te: Double = 0.0, solarzen: Double = 0.0
        var step1: Double = 0.0, step2: Double = 0.0, step3: Double = 0.0
        
        // change sign convention for longitude from negative to positive in western hemisphere
        longitude = lon * -1
        latitude = lat
        if latitude > 89.8 {
            latitude = 89.8
        }
        if latitude < -89.8 {
            latitude = -89.8
        }
        
        // change time zone to ppositive hours in western hemisphere
        zone = Double(timezone * -1)
        daySavings = Double(dlstime * 60)
        hh = Double(hours) - Double(daySavings / 60)
        mm = Double(minutes)
        ss = Double(seconds)
        
        // timenow is GMT time for calculation in hours since 0Z
        timenow = hh + mm / 60 + ss / 3600 + zone
        
        jd = SolarMath.calcJD(year: year, month: month, day: day)
        t = SolarMath.calcTimeJulianCent(jd + timenow / 24.0)
        theta = SolarMath.calcSunDeclination(t)
        eTime = SolarMath.calcEquationOfTime(t)
        
        eqTime = eTime
        solarDec = theta
        
        solarTimeFix = eqTime - 4.0 * longitude + 60.0 * zone
        trueSolarTime = hh * 60.0 + mm + ss / 60.0 + solarTimeFix
        
        while trueSolarTime > 1440 {
            trueSolarTime -= 1440
        }
        
        hourAngle = trueSolarTime / 4.0 - 180.0
        if hourAngle < -180 {
            hourAngle = hourAngle + 360.0
        }
        
        haRad = hourAngle.degToRad
        
        csz = sin(latitude.degToRad) * sin(solarDec.degToRad) +
            cos(latitude.degToRad) * cos(solarDec.degToRad) * cos(haRad)
        
        if csz > 1.0 {
            csz = 1
        } else if csz < -1.0 {
            csz = -1
        }
        
        zenith = acos(csz).radToDeg
        azDenom = cos(latitude.degToRad) * sin(zenith.degToRad)
        
        if abs(azDenom) > 0.0001 {
            azRad = ((sin(latitude.degToRad) * cos(zenith.degToRad)) -
                sin(solarDec.degToRad)) / azDenom
            if abs(azRad) > 1.0 {
                if azRad < 0 {
                    azRad = -1.0
                } else {
                    azRad = 1.0
                }
            }
            azimuth = 180.0 - acos(azRad).radToDeg
            if hourAngle > 0 {
                azimuth = -azimuth
            }
        } else {
            if latitude > 0 {
                azimuth = 180.0
            } else {
                azimuth = 0
            }
        }
        
        if azimuth < 0 {
            azimuth += 360
        }
        
        exoatmElevation = 90.0 - zenith
        
        if exoatmElevation > 85.0 {
            refractionCorrection = 0.0
        } else {
            te = tan(exoatmElevation.degToRad)
            if exoatmElevation > 5.0 {
                refractionCorrection = 58.1 / te - 0.07 / (te * te * te) +
                    0.000086 / (te * te * te * te * te)
            } else if exoatmElevation > -0.575 {
                step1 = (-12.79 + exoatmElevation * 0.711)
                step2 = (103.4 + exoatmElevation * (step1))
                step3 = (-518.2 + exoatmElevation * (step2))
                refractionCorrection = 1735.0 + exoatmElevation * (step3)
            } else {
                refractionCorrection = -20.774 / te
            }
            refractionCorrection /= 3600.0
        }
        
        solarzen = zenith - refractionCorrection
        
        return 90.0 - solarzen
    }
    
    /// Calculate time of dawn  for the entered date and location.
    /// For latitudes greater than 72 degrees N and S, calculations are
    /// accurate to within 10 minutes. For latitudes less than +/- 72°
    /// accuracy is approximately one minute.
    ///
    /// - Parameters:
    ///   - lat: latitude (decimal degrees)
    ///   - lon: longitude (decimal degrees)
    ///   - year: year
    ///   - month: month
    ///   - day: day
    ///   - timezone: time zone hours relative to GMT/UTC (hours)
    ///   - dlstime: daylight savings time (0 = no, 1 = yes) (hours)
    ///   - solardepression: angle of sun below horizon in degrees
    /// - Returns: dawn time in local time (days)
    /// - Note: longitude is negative for western hemisphere for input cells
    /// in the spreadsheet for calls to the functions named
    /// sunrise, solarnoon, and sunset. Those functions convert the
    /// longitude to positive for the western hemisphere for calls to
    /// other functions using the original sign convention
    /// from the NOAA javascript code.
    public static func dawn(lat: Double, lon: Double,
                     year: Int, month: Int, day: Int,
                     timezone: Int, dlstime: Int, solardepression: Double) -> Double {
        var longitude: Double = 0.0, latitude: Double = 0.0, jd: Double = 0.0
        var riseTimeGMT: Double = 0.0, riseTimeLST: Double = 0.0
        
        // change sign convention for longitude from negative to positive in western hemisphere
        longitude = lon * -1
        latitude = lat
        if latitude > 89.8 {
            latitude = 89.8
        }
        if latitude < -89.8 {
            latitude = -89.8
        }
        
        jd = SolarMath.calcJD(year: year, month: month, day: day)
        // Calculate sunrise for this date
        riseTimeGMT = SolarMath.calcDawnUTC(jd: jd, latitude: latitude, longitude: longitude, solardepression: solardepression)
        //  adjust for time zone and daylight savings time in minutes
        riseTimeLST = riseTimeGMT + (60 * Double(timezone)) + Double(dlstime * 60)
        
        //  convert to days
        return riseTimeLST / 1440
    }
    
    /// Calculate time of sunrise  for the entered date and location.
    ///
    /// - Parameters:
    ///   - lat: latitude (decimal degrees)
    ///   - lon: longitude (decimal degrees)
    ///   - year: year
    ///   - month: month
    ///   - day: day
    ///   - timezone: time zone hours relative to GMT/UTC (hours)
    ///   - dlstime: daylight savings time (0 = no, 1 = yes) (hours)
    /// - Returns: sunrise time in local time (days)
    /// - Note: longitude is negative for western hemisphere for input cells
    /// in the spreadsheet for calls to the functions named
    /// sunrise, solarnoon, and sunset. Those functions convert the
    /// longitude to positive for the western hemisphere for calls to
    /// other functions using the original sign convention
    /// from the NOAA javascript code.
    public static func sunrise(lat: Double, lon: Double,
                        year: Int, month: Int, day: Int,
                        timezone: Int, dlstime: Int) -> Double {
        var longitude: Double = 0.0, latitude: Double = 0.0, jd: Double = 0.0
        var riseTimeGMT: Double = 0.0, riseTimeLST: Double = 0.0
        
        // change sign convention for longitude from negative to positive in western hemisphere
        longitude = lon * -1
        latitude = lat
        if latitude > 89.8 {
            latitude = 89.8
        }
        if latitude < -89.8 {
            latitude = -89.8
        }
        
        jd = SolarMath.calcJD(year: year, month: month, day: day)
        // Calculate sunrise for this date
        riseTimeGMT = SolarMath.calcSunriseUTC(JD: jd, latitude: latitude, longitude: longitude)
        
        //  adjust for time zone and daylight savings time in minutes
        riseTimeLST = riseTimeGMT + (60 * Double(timezone)) + Double((dlstime * 60))
        
        //  convert to days
        return riseTimeLST / 1440
    }
    
    /// Calculate the Universal Coordinated Time (UTC) of solar
    /// noon for the given day at the given location on earth
    ///
    /// - Parameters:
    ///   - lat: latitude (decimal degrees)
    ///   - lon: longitude (decimal degrees)
    ///   - year: year
    ///   - month: month
    ///   - day: day
    ///   - timezone: time zone hours relative to GMT/UTC (hours)
    ///   - dlstime: daylight savings time (0 = no, 1 = yes) (hours)
    /// - Returns: time of solar noon in local time days
    /// - Note: longitude is negative for western hemisphere for input cells
    /// in the spreadsheet for calls to the functions named
    /// sunrise, solarnoon, and sunset. Those functions convert the
    /// longitude to positive for the western hemisphere for calls to
    /// other functions using the original sign convention
    /// from the NOAA javascript code.
    public static func solarnoon(lat: Double, lon: Double,
                          year: Int, month: Int, day: Int,
                          timezone: Int, dlstime: Int) -> Double {
        var longitude: Double = 0.0, latitude: Double = 0.0, jd: Double = 0.0
        var t: Double = 0.0, newt: Double = 0.0, eqTime: Double = 0.0
        var solNoonUTC: Double = 0.0
        
        // change sign convention for longitude from negative to positive in western hemisphere
        longitude = lon * -1
        latitude = lat
        if latitude > 89.8 {
            latitude = 89.8
        }
        if latitude < -89.8 {
            latitude = -89.8
        }
        
        jd = SolarMath.calcJD(year: year, month: month, day: day)
        t = SolarMath.calcTimeJulianCent(jd)
        
        newt = SolarMath.calcTimeJulianCent(SolarMath.calcJDFromJulianCent(t) + 0.5 + longitude / 360.0)
        
        eqTime = SolarMath.calcEquationOfTime(newt)
        solNoonUTC = 720 + (longitude * 4) - eqTime
        
        //  adjust for time zone and daylight savings time in minutes and convert to days
        return (solNoonUTC + (60 * Double(timezone)) + Double(dlstime * 60)) / 1440
    }
    
    /// Calculate time of sunrise and sunset for the entered date
    /// and location.
    /// For latitudes greater than 72 degrees N and S, calculations are
    /// accurate to within 10 minutes. For latitudes less than +/- 72°
    /// accuracy is approximately one minute.
    ///
    /// - Parameters:
    ///   - lat: latitude (decimal degrees)
    ///   - lon: longitude (decimal degrees)
    ///   - year: year
    ///   - month: month
    ///   - day: day
    ///   - timezone: time zone hours relative to GMT/UTC (hours)
    ///   - dlstime: daylight savings time (0 = no, 1 = yes) (hours)
    /// - Returns: sunset time in local time (days)
    /// - Note: longitude is negative for western hemisphere for input cells
    /// in the spreadsheet for calls to the functions named
    /// sunrise, solarnoon, and sunset. Those functions convert the
    /// longitude to positive for the western hemisphere for calls to
    /// other functions using the original sign convention
    /// from the NOAA javascript code.
    public static func sunset(lat: Double, lon: Double,
                       year: Int, month: Int, day: Int,
                       timezone: Int, dlstime: Int) -> Double {
        var longitude: Double = 0.0, latitude: Double = 0.0, jd: Double = 0.0
        var setTimeGMT: Double = 0.0, setTimeLST: Double = 0.0
        
        // change sign convention for longitude from negative to positive in western hemisphere
        longitude = lon * -1
        latitude = lat
        if latitude > 89.8 {
            latitude = 89.8
        }
        if latitude < -89.8 {
            latitude = -89.8
        }
        
        jd = SolarMath.calcJD(year: year, month: month, day: day)
        
        // Calculate sunset for this date
        setTimeGMT = SolarMath.calcSunsetUTC(jd: jd, latitude: latitude, longitude: longitude)
        //  adjust for time zone and daylight savings time in minutes
        setTimeLST = setTimeGMT + (60 * Double(timezone)) + Double(dlstime * 60)
        
        //  convert to days
        return setTimeLST / 1440
    }
    
    /// Calculate time of sunrise and sunset for the entered date
    /// and location.
    /// For latitudes greater than 72 degrees N and S, calculations are
    /// accurate to within 10 minutes. For latitudes less than +/- 72°
    /// accuracy is approximately one minute.
    ///
    /// - Parameters:
    ///   - lat: latitude (decimal degrees)
    ///   - lon: longitude (decimal degrees)
    ///   - year: year
    ///   - month: month
    ///   - day: day
    ///   - timezone: time zone hours relative to GMT/UTC (hours)
    ///   - dlstime: daylight savings time (0 = no, 1 = yes) (hours)
    ///   - solardepression: angle of sun below horizon in degrees
    /// - Returns: dusk time in local time (days)
    /// - Note: longitude is negative for western hemisphere for input cells
    /// in the spreadsheet for calls to the functions named
    /// sunrise, solarnoon, and sunset. Those functions convert the
    /// longitude to positive for the western hemisphere for calls to
    /// other functions using the original sign convention
    /// from the NOAA javascript code.
    public static func dusk(lat: Double, lon: Double,
                     year: Int, month: Int, day: Int,
                     timezone: Int, dlstime: Int, solardepression: Double) -> Double {
        var longitude: Double = 0.0, latitude: Double = 0.0, jd: Double = 0.0
        var setTimeGMT: Double = 0.0, setTimeLST: Double = 0.0
        
        // change sign convention for longitude from negative to positive in western hemisphere
        longitude = lon * -1
        latitude = lat
        if latitude > 89.8 {
            latitude = 89.8
        }
        if latitude < -89.8 {
            latitude = -89.8
        }
        
        jd = SolarMath.calcJD(year: year, month: month, day: day)
        // Calculate sunset for this date
        setTimeGMT = SolarMath.calcDuskUTC(jd: jd, latitude: latitude, longitude: longitude, solardepression: solardepression)
        // adjust for time zone and daylight savings time in minutes
        setTimeLST = setTimeGMT + (60 * Double(timezone)) + Double(dlstime * 60)
        
        //  convert to days
        return setTimeLST / 1440
    }
}
