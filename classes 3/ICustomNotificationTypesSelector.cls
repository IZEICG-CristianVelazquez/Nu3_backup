public interface ICustomNotificationTypesSelector extends fflib_ISObjectSelector{
    List<CustomNotificationType> selectByDevName(Set<String> setNames);
}