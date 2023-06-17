import express from 'express';
import config from './package.json' assert { type: "json" };

const PORT = process.env.PORT ?? 5000;
const PREFIX = process.env.PREFIX ?? '/';


const router = express.Router();
router.get('/', (_, res) => res.send('Hello! :)'));
router.get('/v1/health', (_, res) => res.send('Healthy!'));
router.get('/v1/version', (_, res) => res.send(config.version));

const app = express();
// Adding it because ALB routes on /app path prefix
app.use(PREFIX, router);

app.listen(PORT, () => console.log(`Listening on port ${PORT}.`));
