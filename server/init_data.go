package main

import (
	"log"
	"time"
)

// initTestData inserts three test systems into the database
func initTestData(store *Store) error {
	log.Println("📦 Initializing test data...")

	testSystems := []SystemMetric{
		{
			ID:           "server-001",
			Name:         "production-web-01",
			Time:         "UTC-5",
			Location:     "US-East",
			OS:           "Ubuntu 22.04",
			OSIcon:       "logos:ubuntu",
			CPU:          15.3,
			Memory:       42.8,
			Disk:         38.5,
			NetInMBps:    2.5,
			NetOutMBps:   1.8,
			AgentVersion: "1.0.0",
			Alert:        false,
			UpdatedAt:    time.Now().UTC(),
		},
		{
			ID:           "server-002",
			Name:         "staging-db-01",
			Time:         "UTC+0",
			Location:     "EU-West",
			OS:           "Debian 12",
			OSIcon:       "devicon:debian",
			CPU:          28.7,
			Memory:       65.2,
			Disk:         52.3,
			NetInMBps:    0.8,
			NetOutMBps:   0.5,
			AgentVersion: "1.0.0",
			Alert:        false,
			UpdatedAt:    time.Now().UTC(),
		},
		{
			ID:           "server-003",
			Name:         "development-api-01",
			Time:         "UTC+8",
			Location:     "Asia-Pacific",
			OS:           "CentOS 9",
			OSIcon:       "devicon:centos",
			CPU:          8.2,
			Memory:       25.4,
			Disk:         71.6,
			NetInMBps:    0.3,
			NetOutMBps:   0.2,
			AgentVersion: "1.0.0",
			Alert:        true, // This one has an alert
			UpdatedAt:    time.Now().UTC(),
		},
	}

	for _, system := range testSystems {
		if err := store.Upsert(system); err != nil {
			return err
		}
		log.Printf("  ✅ Inserted: %s (%s)", system.Name, system.ID)
	}

	log.Printf("✅ Successfully initialized %d test systems", len(testSystems))
	return nil
}
