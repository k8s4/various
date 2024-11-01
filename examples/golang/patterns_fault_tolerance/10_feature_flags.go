/* Feature flags
Naming
TTL
Back capability
*/

type FeatureFlags struct {
	Flags map[string]bool `json:"flags"`
}

type Config struct {
	FeatureFlags 	*FeatureFlags
	mu		sync.RWMutex
}

func (c *Config) UpdateFeatureFlags(url string) {
	for {
		flags, err := fetch(url)
		if err != nil {
			time.Sleep(10 * time.Second)
			continue
		}

		c.mu.Lock()
		c.FeatureFlags = flags
		c.mu.Unlock()

		time.Sleep(1 * time.Second)
	}
}

func (c *Config) IsFeatureEnabled(feature string) bool {
	c.mu.RLock()
	defer c.mu.RUnlock()
	if c.FeatureFlags == nil {
		return false
	}
	return c.FeatureFlags.Flags[feature]
}

func main() {
	config := &Config{
		FeatureFlags: &FeatureFlags{
			Flags: make(map[string]bool)
		},
	}

	go config.UpdateFeatureFlags(url)
}
