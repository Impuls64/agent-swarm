# AGENTS — WordPress

## Стек

- **Core:** WordPress 6.x
- **Language:** PHP 8.x
- **Frontend:** HTML5, CSS3, JavaScript
- **Database:** MySQL / MariaDB
- **API:** REST API, GraphQL (WPGraphQL)

## Commands

```bash
# Local development
wp server --host=localhost --port=8080

# Install plugin
wp plugin install plugin-name --activate

# Export database
wp db export backup.sql
```

## Project Structure

```
my-theme/
├── style.css              # Theme meta + styles
├── functions.php          # Theme functions
├── index.php              # Fallback
├── single.php             # Single post
├── page.php               # Page
├── archive.php            # Archive
├── header.php             # Header
├── footer.php             # Footer
└── inc/                   # Includes
```

## Theme Development

```php
// style.css (meta)
/*
Theme Name: My Custom Theme
Version: 1.0.0
Author: Developer
*/

// functions.php
add_action('wp_enqueue_scripts', function() {
    wp_enqueue_style('main-style', get_stylesheet_uri());
    wp_enqueue_script('main-js', get_template_directory_uri() . '/js/app.js');
});
```

## REST API

```php
// Register custom endpoint
add_action('rest_api_init', function() {
    register_rest_route('myapi/v1', '/orders/', [
        'methods' => 'GET',
        'callback' => 'get_orders',
    ]);
});

function get_orders() {
    return ['orders' => []];
}
```

## Custom Post Types

```php
add_action('init', function() {
    register_post_type('portfolio', [
        'labels' => ['name' => 'Portfolio'],
        'public' => true,
        'supports' => ['title', 'editor', 'thumbnail'],
    ]);
});
```

## Security

- Use `wp_nonce_field()` for forms
- Escape output: `esc_html()`, `esc_attr()`
- Prepared queries: `$wpdb->prepare()`
- Regular WordPress and plugin updates
- Strong admin passwords

## Do Not Modify

- WordPress core files
- Plugin files directly (use hooks/filters)
- `.htaccess` without backup

## Best Practices

- Use Child Themes for customization
- CPT + ACF for complex data structures
- Caching: WP Rocket, W3 Total Cache
- Image optimization
- Lazy loading
- Minify CSS/JS

## Useful Plugins

- **ACF** — custom fields
- **Yoast SEO** / **Rank Math** — SEO
- **WooCommerce** — shop
- **Contact Form 7** / **Gravity Forms** — forms
- **WPML** / **Polylang** — multilingual

## Prohibited

- Direct DB queries (use WP_Query)
- Hardcoded paths (use `get_template_directory_uri()`)
- Disabling updates
- Secrets in code
- Core file editing
