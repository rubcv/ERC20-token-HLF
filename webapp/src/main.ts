import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import * as morgan from 'morgan';
const json = require('morgan-json');

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.enableCors();

  const morganLogFormat = json({
    timestamp: ':date[iso]',
    generator: 'WebAPP',
    data: ':method :url :status',
  });
  app.use(morgan(morganLogFormat));

  await app.listen(3000);
}
bootstrap();
