const jsonServer = require('json-server');

const server = jsonServer.create();
const router = jsonServer.router('db.json');
const middlewares = jsonServer.defaults();

// 1. Middlewares (logger, CORS, etc.)
server.use(middlewares);

// 2. Body parser (must come BEFORE your custom middleware)
server.use(jsonServer.bodyParser);

// 3. Custom middleware
server.use((req, res, next) => {
  if (req.method === 'POST' && req.path.startsWith('/users')) {
    const db = router.db;
    const users = db.get('users').value();
    const maxId = users.length > 0 ? Math.max(...users.map(u => Number(u.id))) : 0;

    if (!req.body) req.body = {};  // 🔑 ensure body exists
    req.body.id = maxId + 1;
  }

  if ((req.method === 'PUT' || req.method === 'PATCH') && req.body?.id) {
    req.body.id = Number(req.body.id);
  }

  next();
});

// 4. Router
server.use(router);

// 5. Start server
server.listen(3000, () => {
  console.log('JSON Server is running on http://localhost:3000');
});
