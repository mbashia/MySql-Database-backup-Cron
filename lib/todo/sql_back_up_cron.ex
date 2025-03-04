defmodule Todo.SqlBackUpCron do
  require Logger
  # alias ExAws.S3

  # @config Application.fetch_env!(:todo, BackupService)
  @database_password System.get_env("MYSQL_PASS")
  @database_name "todo_dev"
  @backup_path System.get_env("BACKUP_PATH")

  def run_backup do
    timestamp = DateTime.utc_now() |> DateTime.to_string() |> String.replace(~r/[:. ]/, "_")
    filename = "backup_#{timestamp}.sql"

    case dump_database(filename) do
      :ok ->
        ## maybe save to extenal storage and delete existing backup file
        Logger.info("Backup successful")

      error ->
        Logger.error("Backup failed: #{inspect(error)}")
    end
  end

  def dump_database(filename) do
    Logger.info("Creating MySQL dump...")
    # backup_path = "/home/mbashia/projects/todo/priv/backups/#{filename}.sql"
    backup_path = "#{@backup_path}/#{filename}.sql"
    cmd = "mysqldump -u root -p'#{@database_password}' #{@database_name} > #{backup_path}"

    case System.cmd("sh", ["-c", cmd]) do
      {_, 0} ->
        Logger.info("Backup successful: #{backup_path}")
        :ok

      {error_msg, _} ->
        Logger.error("Backup failed: #{error_msg}")
        :error
    end
  end

  # defp upload_to_r2(filename) do
  #   Logger.info("Uploading \#{filename} to Cloudflare R2...")
  #   bucket = @config[:bucket_name]

  #   {:ok, file} = File.read(filename)

  #   S3.put_object(bucket, filename, file)
  #   |> ExAws.request()
  # end

  # defp delete_local_backup(filename) do
  #   Logger.info("Deleting local backup: \#{filename}")
  #   File.rm(filename)
  # end
end
