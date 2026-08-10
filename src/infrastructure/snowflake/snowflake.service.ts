import { Injectable } from '@nestjs/common';
import { Snowflake } from '@sapphire/snowflake';

@Injectable()
export class SnowflakeService {
  private readonly generator: Snowflake;

  constructor() {
    const workerId = Number(process.env.SNOWFLAKE_WORKER_ID ?? 1);

    this.generator = new Snowflake(workerId);
  }

  generate(): bigint {
    return this.generator.generate();
  }

  generateString(): string {
    return this.generate().toString();
  }
}
