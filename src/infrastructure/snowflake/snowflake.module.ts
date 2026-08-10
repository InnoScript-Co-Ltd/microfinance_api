import { Global, Module } from '@nestjs/common';
import { SnowflakeService } from './snowflake.service';

@Global()
@Module({
  providers: [],
  exports: [SnowflakeService],
})
export class SnowflakeModule {}
