# Constants

All of them are under the `nimic` namespace. The terminology `clients|client` is analogous to `hosts|host`.

> [!important]
> All of them must be set to some value, their type described in the table below
> If a module that uses the option isn't used, `false` will be declared

| Option name | Type | Description |
| ----------- | ---- | ----------- |
| `user`  | `str` | Sets the username used for a `client` |
| `flake` | `str` | Sets where this flake currently resides (path/repo) |
| `email` | `str` | Git email address (noreply) |
| `gitName`| `str` | Git username |
| `nvidia.prime` | `bool` | Enables PRIME |
| `nvidia.amdgpuBusId` | `str` | Specifies the bus ID for AMDGPU |
| `nvidia.nvidiaBusId` | `str` | Specifies the bus ID for NVIDIA |
| `nvidia.perDinam` | `bool` | Enables Persistenced & dynamicBoost |
| `domain` | `str` | Base domain name |
| `acmeEmail` | `str` | Email to use with ACME |
