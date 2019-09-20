package internal

import (
	"fmt"
	"gopkg.in/yaml.v2"
	"net/http"
)

// MapHandler will return an http.HandlerFunc (which also
// implements http.Handler) that will attempt to map any
// paths (keys in the map) to their corresponding URL (values
// that each key in the map points to, in string format).
// If the path is not provided in the map, then the fallback
// http.Handler will be called instead.
func MapHandler(pathsToUrls map[string]string, fallback http.Handler) http.HandlerFunc {
	return http.HandlerFunc(func(res http.ResponseWriter, req *http.Request) {
		// Need to get the short URL after the / in the URL the request has come from
		// Redirect to the mapped URL if found
		// Else go to fallback handler
		path := req.URL.Path
		if val, ok := pathsToUrls[path]; ok {
			res.Header().Add("Content-Type", "")
			http.Redirect(res, req, val, http.StatusMovedPermanently)
		}

		fallback.ServeHTTP(res, req)
	})
}

// YAMLHandler will parse the provided YAML and then return
// an http.HandlerFunc (which also implements http.Handler)
// that will attempt to map any paths to their corresponding
// URL. If the path is not provided in the YAML, then the
// fallback http.Handler will be called instead.
//
// YAML is expected to be in the format:
//
//     - path: /some-path
//       url: https://www.some-url.com/demo
//
// The only errors that can be returned all related to having
// invalid YAML data.
//
// See MapHandler to create a similar http.HandlerFunc via
// a mapping of paths to urls.
func YAMLHandler(yml []byte, fallback http.Handler) (http.HandlerFunc, error) {
	parsedYaml, err := parseYAML(yml)
	if err != nil {
		return nil, err
	}
	fmt.Printf("%v\n", parsedYaml)
	pathMap := buildMap(parsedYaml)
	return MapHandler(pathMap, fallback), nil
}

func parseYAML(yml []byte) ([]yamlStruct, error) {
	var yamlStructs []yamlStruct
	err := yaml.Unmarshal(yml, &yamlStructs)
	if err != nil {
		return nil, err
	}

	fmt.Printf("%v", yamlStructs)

	return yamlStructs, nil
}

type yamlStruct struct {
	Path string `yaml:"path"`
	URL  string `yaml:"url"`
}

func buildMap(items []yamlStruct) map[string]string {
	urlMap := make(map[string]string, len(items))

	for _, val := range items {
		urlMap[val.Path] = val.URL
	}

	return urlMap
}
