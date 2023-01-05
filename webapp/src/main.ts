import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import * as morgan from 'morgan';
const json = require('morgan-json');
const bodyParser = require('body-parser');

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.enableCors();
  app.use(bodyParser.json());

  const morganLogFormat = json({
    timestamp: ':date[iso]',
    generator: 'WebAPP',
    data: ':method :url :status',
  });
  app.use(morgan(morganLogFormat));

  await app.listen(3000);
}
bootstrap();
