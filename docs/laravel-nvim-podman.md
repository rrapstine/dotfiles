# Laravel.nvim with Podman Integration

This configuration provides seamless Laravel.nvim integration with podman-compose environments.

## Features

### Lazy Container Detection
- **No startup prompts**: Container name is only requested when needed
- **Project-aware**: Only prompts when in actual Laravel projects (with `artisan` file)
- **Environment variable support**: Set `LARAVEL_NVIM_CONTAINER=mycontainer` to skip prompts entirely

### Smart Defaults
- Default container name: `api`
- Supports: php, composer, npm, yarn, artisan commands
- Cached per session to avoid repeated prompts

### Key Bindings

| Key | Command | Description |
|-----|---------|-------------|
| `<leader>ll` | Laravel Picker | Open main Laravel menu |
| `<leader>la` | Artisan Picker | Run artisan commands |
| `<leader>le` | Configure Environment | Laravel environment selector |
| `<leader>lE` | Reset Container | Reset cached container name |
| `<leader>lr` | Routes Picker | Browse Laravel routes |
| `<leader>lm` | Make Picker | Generate Laravel files |

## Usage

### First Time Setup
1. Navigate to a Laravel project (must have `artisan` file)
2. Use any Laravel.nvim command (e.g., `<leader>la`)
3. When prompted, enter your container name (default: `api`)

### Environment Variable Setup
Add to your project's `.envrc` or shell profile:
```bash
export LARAVEL_NVIM_CONTAINER=api
```

### Container Reset
If you need to change container names mid-session:
- Press `<leader>lE` to reset the cached container name
- Next Laravel command will prompt for new container name

## Container Commands

The integration maps Laravel tools to podman-compose:

- **PHP**: `podman compose exec -it <container> php`
- **Composer**: `podman compose exec -it <container> composer`
- **NPM**: `podman compose exec -it <container> npm`
- **Yarn**: `podman compose exec -it <container> yarn`
- **Artisan**: `podman compose exec -it <container> php artisan`

## PHPActor LSP Integration

PHPActor is configured to work alongside Laravel.nvim with:
- Robust path resolution for container environments
- URI error prevention
- Focused on refactoring capabilities (complements intelephense)

## Troubleshooting

### Container Prompt on Every Start
- Make sure you're in a Laravel project directory (has `artisan` file)
- Or set `LARAVEL_NVIM_CONTAINER` environment variable

### PHPActor URI Errors
- Updated configuration includes better path normalization
- Uses absolute paths and proper root directory detection

### Commands Not Working
- Verify your `podman-compose.yml` has the correct service name
- Use `<leader>lE` to reset and re-enter container name