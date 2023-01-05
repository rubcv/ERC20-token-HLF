import { Body, Controller, Get, Post, Res } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('/query')
  public async Query(@Body() func: string, @Body() args: any): Promise<any> {
    return this.appService.query(func, args);
  }

  @Post('/invoke')
  public async Invoke(@Body() func: string, @Body() args: any): Promise<any> {
    return this.appService.invoke(func, args);
  }
}
