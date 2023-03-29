public with sharing class CarteraClientesController {

    @AuraEnabled
    public static Map<String, Object> obtenerDatosCartera (String accountId, String userId) {

        Map<String, Object> resultMap = new Map<String, Object>();

		userId = String.isBlank(userId) ? UserInfo.getUserId() : userId;

        User currentUser = new Userselector().selectById(new Set<Id>{userId}).get(0);
        List<Account> acctLst = new AccountsSelector().selectById(new Set<Id>{accountId});

        if (!acctLst.isEmpty()) {

            resultMap.put('cliente', acctLst.get(0));

        }

        resultMap.put('usuario', currentUser);

        return resultMap;

    }

    /**
	 * Clase usada para enviar opciones de picklist a los componentes
	 */
	public class SelectOptions {

		@AuraEnabled public String label { get; set; }
		@AuraEnabled public String value { get; set; }

		public SelectOptions (String label, String value) {

			this.label = label;
			this.value = value;

		}

	}

    /**
	 * Devuelve los valores de picklist de los usuarios con subroles
	 * @return List<SelectOptions> con los valores
	 */
	@AuraEnabled
	public static List<SelectOptions> obtenerValoresUsuarios (String accountId) {

		List<SelectOptions> options = new List<SelectOptions>();

        Set<Id> setUserIds = RoleUtils.getRoleSubordinateUsers(UserInfo.getUserId());

		options.add( new SelectOptions('-- Seleccionar --', UserInfo.getUserId()) );

		if (String.isNotBlank( accountId)) {

			options.add( new SelectOptions('Todos', UserInfo.getUserId()) );

		}

		options.add( new SelectOptions(UserInfo.getName(), UserInfo.getUserId()) );

		for ( User u : new UserSelector().selectById(setUserIds) ) {

			options.add( new SelectOptions(u.Name, u.Id) );

		}
		
		return options;

	}

}