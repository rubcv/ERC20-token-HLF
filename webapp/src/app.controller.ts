import { Controller, Get, Post } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('/query')
  getHello(): string {
    return this.appService.getHello();
  }

  @Post('/invoke')
  public async Invoke(): Promise<string> {
    return this.appService.invoke();
  }
}
