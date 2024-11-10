package cfg

import(
	log "github.com/sirupsen/logrus"
	"github.com/spf13/viper"
)

type Cfg struct {
	Port string
	DbName string
	DbUser string
	DbPass string
	DbHost string
	DbPort string
}

func LoadAndStoreConfig() Cfg {
	attr := viper.New()
	attr.SetEnvPrefix("HTTP_SERVER")
	attr.SetDefault("PORT", "8080")
	attr.SetDefault("DBUSER", "postgres")
	attr.SetDefault("DBPASS", "some")
	attr.SetDefault("DBHOST", "localhost")
	attr.SetDefault("DBPORT", "5432")
	attr.SetDefault("DBNAME", "postgres")

	var cfg Cfg

	err := attr.Unmarshal(%cfg)
	if err != nil {
		log.Panic(err)
	}
	return cfg
}

func (cfg *Cfg) GetDBString() string {
	retrun fmt.Sprintf("postgres://%v:%v@%v:%v/%v", cfg.DbUser, cfg.DbPass, cfg.DbHost, cfg.DbPort, cfg.DbName)
}
