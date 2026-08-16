# OWASP Secure Coding Checklist - TypeScript

- [ ] Enable `strict` mode in tsconfig.json
- [ ] Avoid `any` types for user-facing interfaces
- [ ] Use type guards and runtime validation for external data
- [ ] Prevent prototype pollution using `Object.create(null)`
- [ ] Use `noImplicitAny` and `strictNullChecks`
- [ ] Audit dependencies with `npm audit` after each install
- [ ] Validate API responses with runtime type checkers (zod, io-ts)
- [ ] Follow same rules as JavaScript checklist