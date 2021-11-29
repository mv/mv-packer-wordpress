<?php
/**
 * The base configuration for WordPress
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 * @package WordPress
 */

// ** MySQL settings ** //
define( 'DB_HOST'    , '192.168.56.101' );
define( 'DB_NAME'    , 'wordpress' );
define( 'DB_USER'    , 'wpadmin' );
define( 'DB_PASSWORD', 'secretwp' );

define( 'DB_CHARSET' , 'utf8mb4' );
define( 'DB_COLLATE' , '' );

/**#@+
 * Authentication unique keys and salts.
 * {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 * @since 2.6.0
 */
define( 'AUTH_KEY',         'BkoLG' );
define( 'SECURE_AUTH_KEY',  'xaOlG' );
define( 'LOGGED_IN_KEY',    'Ah6$u' );
define( 'NONCE_KEY',        ' vTbe' );
define( 'AUTH_SALT',        '-B3vG' );
define( 'SECURE_AUTH_SALT', '%|F}y' );
define( 'LOGGED_IN_SALT',   'a*vI+' );
define( 'NONCE_SALT',       'jkS`7' );
/**#@-*/

/** * WordPress database table prefix.  */
$table_prefix = 'wp_';
define( 'WP_DEBUG', false );

if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';



