import express from 'express';
import { version }  from './package.json'

const app = express();

app.get('/', (_, res) => res.send('Hello!'));

app.get('/version', (_, res) => res.send(version));

app.listen(8080);
