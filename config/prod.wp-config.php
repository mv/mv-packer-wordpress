<?php

define( 'WP_DEBUG', false );

if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}


/* SECURITY: created only at boot time */
require_once ABSPATH . 'wp-config.db-access.php';
require_once ABSPATH . 'wp-config.salt-keys.php';



/* all other settings */
require_once ABSPATH . 'wp-settings.php';



