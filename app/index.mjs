import express from 'express';
import config from './package.json' assert { type: "json" };

const app = express();

app.get('/', (_, res) => res.send('Hello!'));

app.get('/version', (_, res) => res.send(config.version));

app.listen(80);
