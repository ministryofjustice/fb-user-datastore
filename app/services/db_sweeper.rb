class DbSweeper
  def call
    UserData.where("created_at < ?", age_threshold).destroy_all
    SavedForm.where("created_at < ?", invalidation_threshold).each do |record| 
      record.invalidate_user_fields!
    end
    SavedForm.where("created_at < ?", destroy_saved_progress_threshold).destroy_all
  end

  private

  def age_threshold
    28.days.ago
  end

  def invalidation_threshold
    28.days.ago
  end

  def destroy_saved_progress_threshold
    60.days.ago
  end
end
