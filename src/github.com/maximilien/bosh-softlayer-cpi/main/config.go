package main

import (
	"encoding/json"

	bosherr "github.com/cloudfoundry/bosh-utils/errors"
	boshsys "github.com/cloudfoundry/bosh-utils/system"

	bslcvm "github.com/maximilien/bosh-softlayer-cpi/softlayer/vm"
)

type Config struct {
	Cloud CloudConfig `json:"cloud"`
}

type SoftLayerConfig struct {
	Username string `json:"username"`
	ApiKey   string `json:"apiKey"`
}

type CloudProperties struct {
    Softlayer SoftLayerConfig `json:"softlayer"`
	Agent bslcvm.AgentOptions `json:"agent"`
}

type CloudConfig struct {
	Plugin string `json:"plugin"`
	Properties CloudProperties `json:"properties"`
}

func NewConfigFromPath(path string, fs boshsys.FileSystem) (Config, error) {
	var config Config

	bytes, err := fs.ReadFile(path)
	if err != nil {
		return config, bosherr.WrapErrorf(err, "Reading config %s", path)
	}

	err = json.Unmarshal(bytes, &config)
	if err != nil {
		return config, bosherr.WrapError(err, "Unmarshalling config")
	}

	err = config.Validate()
	if err != nil {
		return config, bosherr.WrapError(err, "Validating config")
	}

	return config, nil
}

func (c Config) Validate() error {
	err := c.Cloud.Properties.Softlayer.Validate()
	if err != nil {
		return bosherr.WrapError(err, "Validating SoftLayer configuration")
	}

	return nil
}

func (c SoftLayerConfig) Validate() error {
	if c.Username == "" {
		return bosherr.Error("Must provide non-empty Username")
	}

	if c.ApiKey == "" {
		return bosherr.Error("Must provide non-empty ApiKey")
	}

	return nil
}
