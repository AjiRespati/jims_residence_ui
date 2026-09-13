# Residenza frontend

## API environment

The API endpoint is chosen at build time. Do not change
`lib/application_info.dart` or uncomment URLs before building.

### Development

The default API endpoint is local:

- Web: `http://localhost:3300`
- Android emulator: `http://10.0.2.2:3300`

Run normally:

```bash
flutter run
```

### Production web build

Build the production web app with the production environment and endpoint:

```bash
flutter build web --release \
  --dart-define=APP_ENV=prod \
  --dart-define=MAIN_URL=https://residenza.id
```

The resulting files are in `build/web`. The application will call
`https://residenza.id/service/api` and will not show the `DEV` version label.

`APP_ENV=prod` alone also defaults to `https://residenza.id`; pass `MAIN_URL`
explicitly when building so the deployment endpoint is clear and easy to audit.
