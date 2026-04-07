# Constants

All of them are under the `nimic` namespace. The terminology `clients|client` is analogous to `hosts|host`.

> [!important]
> All of them must be set to some value, their type described in the table below
> If a module that uses the option isn't used, `false` will be declared

| Option name | Type | Description |
| ----------- | ---- | ----------- |
| `email` | `str` | Git email address (noreply) |
| `flake` | `str` | Sets where this flake currently resides (path/repo) |
| `gitName`| `str` | Git username |
| `user`  | `str` | Sets the username used for a `client` |
