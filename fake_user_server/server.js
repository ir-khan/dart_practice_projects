const jsonServer = require('json-server');

const server = jsonServer.create();
const router = jsonServer.router('db.json');
const middlewares = jsonServer.defaults();

server.use(middlewares);

server.use(jsonServer.bodyParser);

server.use((req, res, next) => {
  if (req.method === 'POST' && req.path.startsWith('/users')) {
    const db = router.db;
    const users = db.get('users').value();
    const maxId = users.length > 0 ? Math.max(...users.map(u => Number(u.id))) : 0;

    if (!req.body) req.body = {};
    req.body.id = maxId + 1;
  }

  if ((req.method === 'PUT' || req.method === 'PATCH') && req.body?.id) {
    req.body.id = Number(req.body.id);
  }

  next();
});

server.use(router);

server.listen(3000, () => {
  console.log('JSON Server is running on http://localhost:3000');
});
