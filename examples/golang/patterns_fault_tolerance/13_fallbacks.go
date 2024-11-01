/* Fallbacks / graceful degradation
tests
dynamic/multilevel fallback
*/

func getHotelAvailability() (string, error) {
	result, err := getFromDatabase()
	if err != nil {
		return fallbackFromCache(), nil
	}
	return result, nil
}
