extends Node

const HUMAN_MONTH_NAMES: Array[String] = [
	"january",
	"february",
	"march",
	"april",
	"may",
	"june",
	"july",
	"august",
	"september",
	"october",
	"november",
	"december",
]
const DWARVEN_MONTH_NAMES: Array[String] = [
	"copper",
	"brass",
	"bronze",
	"iron",
	"nickel",
	"carbide",
	"steel",
	"lead",
	"platinum",
	"tin",
	"zinc",
	"silver",
	"gold",
]
const ELVEN_MONTH_NAMES: Array[String] = [
	"first_light",
	"frostpetal",
	"shadowbloom",
	"duskblossom",
	"awakening",
	"second_embrace",
	"ember_veil",
	"solstice",
	"dawn_seed",
	"last_embrace",
	"moon_veil",
	"silver_tide",
	"last_petal",
	"equilibrium",
	"rebirth",
]
const ELVEN_MOON_PHASE_NAMES: Array[String] = [
	"new_moon",
	"waxing_moon",
	"full_moon",
	"waning_moon",
]
const DEMON_MAJOR_MOON_CYCLE_TIME := 35.263
const DEMON_MINOR_MOON_CYCLE_TIME := 27.224

func _day_to_string(day: int) -> String:
	match day:
		1:
			return "1st"
		2:
			return "2nd"
	return str(day) + "th"


# Gregorian calender
# The date format is: {month day} {month} of {year}
func get_human_date(time: int) -> String:
	var date_dict := Time.get_datetime_dict_from_unix_time(time)
	var day := self._day_to_string(date_dict.get("day", 1) as int)
	var month := tr(self.HUMAN_MONTH_NAMES[date_dict.get("month", 1) - 1 as int].to_upper())
	var year := str(date_dict.get("year", 0) - 1700)
	return day + " " + month + " " + tr("OF") + " " + year

func _get_dwarven_month(days: int, year: int) -> int:
	for month in range(13):
		var days_this_month := 28 + int(month == 6) + int(month == 7 and year % 4 == 0)
		if days < days_this_month:
			return month
		days -= days_this_month
	return 12


# 13 months per year
# The seventh moonth has 29 days, other months have 28 days
# In leap years, the eight month has 29 days as well
# The date format is: {month day} {month} {year}
func get_dwarven_date(time: int) -> String:
	var year := floori(time / (365.25 * 24 * 60 * 60))
	var rest_days := floori(time / (24.0 * 60.0 * 60.0) - (year * 365.0 + floori(year / 4.0)))
	var month_index := self._get_dwarven_month(rest_days, year)
	var month_day := rest_days - month_index * 28 + int(month_index >= 6) + int(month_index >= 7 and year % 4 == 0)
	var day := self._day_to_string(month_day + 1)
	var month := tr(self.DWARVEN_MONTH_NAMES[month_index].to_upper()).capitalize()
	return day + " " + month + " " + str(505 + year)


# Each months starts with new moon. Therefore, a month has either 27 or 28 days.
# Every third year has 14 months, the others have 13 months. Every 30 years there is a 15th month.
# The date format is: {moon phase day} {month}'s {moon phase} {year}
func get_elven_date(time: int) -> String:
	var monthly_diff := 0.0
	var current_year := 0
	var current_month: int
	var current_day: int
	
	while time >= 0:
		for month_index in range(13 + int(current_year % 3 == 0) + int(current_year % 30 == 0)):
			var days_this_month := 27 + int(monthly_diff > 1.0)
			
			if time < days_this_month * 24 * 60 * 60:
				current_month = month_index
				current_day = floori(time / (24.0 * 60.0 * 60.0))
				time -= days_this_month * 24 * 60 * 60
				break
			else:
				time -= days_this_month * 24 * 60 * 60
				monthly_diff += 0.3217 * (days_this_month - 27.0)
		if time >= 0:
			current_year += 1
	
	var phase := mini(floori(current_day * self.ELVEN_MOON_PHASE_NAMES.size() / 27.0),
		self.ELVEN_MOON_PHASE_NAMES.size() - 1)
	var phase_day := current_day - phase * ceili(27.0 / self.ELVEN_MOON_PHASE_NAMES.size())
	var phase_name := self.ELVEN_MOON_PHASE_NAMES[phase]
	var day := self._day_to_string(phase_day + 1)
	var month := tr(self.ELVEN_MONTH_NAMES[current_month].to_upper()).capitalize()
	return day + " " + month + "'s " + tr(phase_name.to_upper()).capitalize() + " " + str(1111 + current_year)


func _get_demon_day_name(major_moon_phase: float, minor_moon_phase: float) -> String:
	if (major_moon_phase < 0.2 or major_moon_phase > 0.8) and (minor_moon_phase < 0.2 or minor_moon_phase > 0.8):
		return "calamity"
	elif (major_moon_phase > 0.2 and major_moon_phase < 0.5) and (minor_moon_phase > 0.2 and minor_moon_phase < 0.5):
		return "recede"
	elif major_moon_phase > 0.6 and (minor_moon_phase > 0.3 and minor_moon_phase < 0.7):
		return "converge"
	elif minor_moon_phase > 0.6 and (major_moon_phase > 0.3 and major_moon_phase < 0.7):
		return "divergence"
	elif ((major_moon_phase > 0.15 and major_moon_phase < 0.35) or (major_moon_phase > 0.65 and major_moon_phase < 0.85)) and ((minor_moon_phase > 0.15 and minor_moon_phase < 0.35) or (minor_moon_phase > 0.65 and minor_moon_phase < 0.85)):
		return "balance"
	elif (major_moon_phase > 0.4 and major_moon_phase < 0.6) and (minor_moon_phase > 0.4 and minor_moon_phase < 0.6):
		return "silence"
	elif (major_moon_phase < 0.2 or major_moon_phase > 0.8) and (minor_moon_phase > 0.3 and minor_moon_phase < 0.7):
		return "embrace"
	elif (major_moon_phase > 0.6 and major_moon_phase < 0.8) and (minor_moon_phase > 0.6 and minor_moon_phase < 0.8):
		return "storm"
	elif absf(absf(major_moon_phase - minor_moon_phase) - 0.5) < 0.2:
		return "fracture"
	elif major_moon_phase < 0.25 or major_moon_phase > 0.75:
		return "fire"
	elif minor_moon_phase < 0.25 or minor_moon_phase > 0.75:
		return "ash"
	elif major_moon_phase > 0.25 and major_moon_phase < 0.75:
		return "calm"
	elif minor_moon_phase > 0.25 and minor_moon_phase < 0.75:
		return "surge"
	return "whirl"

func _get_demon_day_number(day_name: String, year: int, time: int) -> int:
	var current_time := year * 960 * 24 * 60 * 60
	var count := 0
	var previous_day_name := ""
	while current_time < time:
		var major_moon_phase := self._get_demon_major_moon_phase(current_time)
		var minor_moon_phase := self._get_demon_minor_moon_phase(current_time)
		var new_day_name := self._get_demon_day_name(major_moon_phase, minor_moon_phase)
		count += int(new_day_name != previous_day_name and new_day_name == day_name)
		previous_day_name = new_day_name
		current_time += 24 * 60 * 60
	return maxi(count, 1)

func _get_demon_major_moon_phase(time: int) -> float:
	return fmod(time / (DEMON_MAJOR_MOON_CYCLE_TIME * 24.0 * 60.0 * 60.0), 1.0)

func _get_demon_minor_moon_phase(time: int) -> float:
	return fmod(time / (DEMON_MAJOR_MOON_CYCLE_TIME * 24.0 * 60.0 * 60.0), 1.0)

func get_demon_date(time: int) -> String:
	var year := floori(time / (960.0 * 24.0 * 60.0 * 60.0))
	var major_moon_phase := self._get_demon_major_moon_phase(time)
	var minor_moon_phase := self._get_demon_minor_moon_phase(time)
	var day_name := self._get_demon_day_name(major_moon_phase, minor_moon_phase)
	var day := self._day_to_string(self._get_demon_day_number(day_name, year, time))
	return day + " " + tr(day_name.to_upper()) + " " + tr("OF") + " " + tr("THE") + " " + self._day_to_string(year) + " " + tr("EPOCH")


func get_date_by_race(time: int, race: String) -> String:
	if "dwarf" in race:
		return self.get_dwarven_date(time)
	if "elf" in race:
		return self.get_elven_date(time)
	if "demon" in race:
		return self.get_demon_date(time)
	return self.get_human_date(time)
