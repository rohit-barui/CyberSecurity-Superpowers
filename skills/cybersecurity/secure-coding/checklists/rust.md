# OWASP Secure Coding Checklist - Rust

- [ ] Use safe Rust and verify `unsafe` blocks are unavoidable
- [ ] Avoid `std::process::Command` with shell features
- [ ] Use `ring` or `rustls` for cryptography
- [ ] Validate all input sizes and types at boundaries
- [ ] Disallow unsafe SQL with `diesel` or use parameterized queries
- [ ] Use `cargo audit` for dependency vulnerability scanning
- [ ] Set `deny` for `unsafe_code` in clippy rules
- [ ] Use `serde` with strict deserialization parameters
- [ ] Avoid `std::mem::transmute` unless absolutely required
- [ ] Pin transitive dependency versions in Cargo.lock