import { Controller, Get, Post } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('/query')
  public async Query(): Promise<any> {
    return this.appService.query();
  }

  @Post('/invoke')
  public async Invoke(): Promise<any> {
    return this.appService.invoke();
  }
}
