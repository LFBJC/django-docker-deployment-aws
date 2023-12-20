import time
from psycopg2 import OperationalError as Psycopg2OpError
from django.db.utils import OperationalError
from django.core.management.base import BaseCommand

class WaitForDBCommand(BaseCommand):
    """Django command to wait for the database"""

    def handle(self, *args, **options):
        """Entrypoint for command"""
        self.stdout.write('Waiting for database...')
        db_up = False
        while not db_up:
            try:
                self.check(database=['default'])
                db_up = True
            # If the database is not ready the function check will throw different errors depending on the stage in
            # which the database is starting up, so the except block needs to catch these two errors
            except (Psycopg2OpError, OperationalError):
                self.stdout.write('Database unavailable, waiting 1 second')
                time.sleep(1)
        self.stdout.write(self.style.SUCCESS('Database Ready!'))