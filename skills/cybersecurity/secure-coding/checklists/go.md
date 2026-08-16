# OWASP Secure Coding Checklist - Go

- [ ] Use `database/sql` parameterized queries
- [ ] Avoid `crypto/md5` and `crypto/sha1` for security purposes
- [ ] Use `crypto/rand` for random number generation
- [ ] Validate all input sizes to prevent resource exhaustion
- [ ] Use `html/template` for auto-escaping HTML output
- [ ] Check error returns diligently (no silent swallows)
- [ ] Use `gosec` for static security analysis
- [ ] Set timeouts on all network operations
- [ ] Avoid `unsafe` package unless absolutely necessary
- [ ] Use `go mod verify` to check dependency integrity