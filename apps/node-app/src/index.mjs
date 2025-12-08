import express from 'express';
import config from './package.json' with { type: "json" };

const PORT = process.env.PORT ?? 5000;

const router = express.Router();
router.get('/', (_, res) => res.send('Hello! :)'));
router.get('/v1/health', (_, res) => res.send('Healthy!'));
router.get('/v1/version', (_, res) => res.send(config.version));

const app = express();
app.use('/', router);

app.listen(PORT, () => console.log(`Listening on port ${PORT}.`));
