  - name: Use Node.js
    uses: actions/setup-node@v4
    with:
      node-version: 18
      cache: 'npm'

  - name: Install dependencies
    run: npm ci

  - name: Wait for Mongo to be ready
    run: |
      for i in $(seq 1 20); do
        mongosh --host localhost --eval 'db.runCommand({ ping: 1 })' && break || sleep 1
      done

  - name: Lint
    run: npm run lint || true

  - name: Run unit tests
    env:
      MONGODB_URI: mongodb://localhost:27017/nest_ci
      JWT_SECRET: test_secret
    run: npm run test -- --ci --runInBand

  - name: Build
    run: npm run build
