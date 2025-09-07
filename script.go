package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
	"time"
)

// Configuration structure
type Config struct {
	RootDir     string   // Root directory to start scanning
	OutputFile  string   // Output markdown file
	FileTypes   []string // File extensions to include
	IgnoreDirs  []string // Directories to ignore
	ProjectName string   // Name of the project
}

func main() {
	// Configure the script
	config := Config{
		RootDir:     "./", // Change this to your NixOS config root
		OutputFile:  "nixos-config-summary.md",
		FileTypes:   []string{".nix", ".md", ".toml"},
		IgnoreDirs:  []string{".git", "result"},
		ProjectName: "My NixOS Configuration",
	}

	// Generate the markdown
	err := generateMarkdown(config)
	if err != nil {
		fmt.Printf("Error generating markdown: %v\n", err)
		os.Exit(1)
	}

	fmt.Printf("Successfully generated markdown at %s\n", config.OutputFile)
}

func generateMarkdown(config Config) error {
	// Open output file
	file, err := os.Create(config.OutputFile)
	if err != nil {
		return err
	}
	defer file.Close()

	// Write header
	now := time.Now().Format("January 2, 2006")
	header := fmt.Sprintf("# %s\n\n", config.ProjectName)
	header += fmt.Sprintf("*Generated on %s*\n\n", now)
	header += "## Table of Contents\n\n"

	// We'll fill this in later
	tableOfContents := ""

	// Write introduction
	intro := "## Overview\n\n"
	intro += "This document contains a comprehensive overview of my NixOS configuration files.\n\n"

	// Initial content with header and intro
	content := header + tableOfContents + intro

	// Scan directory and generate file sections
	fileSections := ""
	sectionsList := []string{}

	err = filepath.Walk(config.RootDir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		// Skip directories we want to ignore
		if info.IsDir() {
			for _, dir := range config.IgnoreDirs {
				if strings.HasSuffix(path, dir) {
					return filepath.SkipDir
				}
			}
			return nil
		}

		// Check if file extension is in our list
		ext := filepath.Ext(path)
		include := false
		for _, fileType := range config.FileTypes {
			if ext == fileType {
				include = true
				break
			}
		}

		if !include {
			return nil
		}

		// Read file content
		fileContent, err := ioutil.ReadFile(path)
		if err != nil {
			return err
		}

		// Make path relative to root
		relPath, err := filepath.Rel(config.RootDir, path)
		if err != nil {
			return err
		}

		// Create section title
		sectionTitle := fmt.Sprintf("## %s", relPath)
		sectionsList = append(sectionsList, relPath)

		// Create section
		section := fmt.Sprintf("%s\n\n", sectionTitle)
		section += "```" + strings.TrimPrefix(ext, ".") + "\n"
		section += string(fileContent) + "\n"
		section += "```\n\n"

		fileSections += section
		return nil
	})

	if err != nil {
		return err
	}

	// Generate table of contents
	for _, section := range sectionsList {
		tableOfContents += fmt.Sprintf("- [%s](#%s)\n", section, strings.Replace(section, "/", "", -1))
	}
	tableOfContents += "\n"

	// Combine everything
	content = header + tableOfContents + intro + fileSections

	// Write to file
	_, err = file.WriteString(content)
	return err
}
