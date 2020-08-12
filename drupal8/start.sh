#!/bin/bash

# Force drupal cache clean up
drush cr

# Start apache
apache2-foreground