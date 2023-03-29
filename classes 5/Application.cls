/**
 * Copyright (c), FinancialForce.com, inc
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, 
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, 
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, 
 *      this list of conditions and the following disclaimer in the documentation 
 *      and/or other materials provided with the distribution. 
 * - Neither the name of the FinancialForce.com, inc nor the names of its contributors 
 *      may be used to endorse or promote products derived from this software without 
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

public class Application {

    // Configure and create the UnitOfWorkFactory for this Application
	public static final fflib_Application.UnitOfWorkFactory UnitOfWork = 
        new fflib_Application.UnitOfWorkFactory(
            new List<SObjectType> { 
                Factura__c.SObjectType,
                Producto_de_Factura__c.SObjectType,
                OrderItem.SObjectType, 
                Detalle_de_encuesta__c.SObjectType,
                Account.SObjectType,
                Error_Log__c.SObjectType,
                Order.SObjectType
            }
        );

    // Configure and create the ServiceFactory for this Application
	public static final fflib_Application.ServiceFactory Service = 
        new fflib_Application.ServiceFactory( 
            new Map<Type, Type> {
                IFacturaService.class => FacturaServiceImpl.class
            }
        );

    // Configure and create the SelectorFactory for this Application
	public static final fflib_Application.SelectorFactory Selector = 
        new fflib_Application.SelectorFactory(
            new Map<SObjectType, Type> {
                Factura__c.SObjectType => FacturasSelector.class,
                Producto_de_Factura__c.SObjectType => ProductosDeFacturaSelector.class,
                Agente__c.SObjectType => AgentesSelector.class,
                Account.SObjectType => AccountsSelector.class,
                Order.SObjectType => OrdersSelector.class,
                PermissionSetAssignment.SObjectType => PermissionSetAssignmentsSelector.class,
                Registro_Choferes_Pedidos__c.SObjectType => RegistroChoferesPedidosSelector.class,
                PriceBookEntry.SObjectType => PriceBookEntriesSelector.class,
                Product2.SObjectType => ProductsSelector.class,
                CustomNotificationType.SObjectType => CustomNotificationTypesSelector.class,
                Group.SObjectType => GroupsSelector.class,
                GroupMember.SObjectType => GroupMembersSelector.class,
                Product2.SObjectType => ProductsSelector.class
            }
        );

    // Configure and create the DomainFactory for this Application
	public static final fflib_Application.DomainFactory Domain = 
        new fflib_Application.DomainFactory(
            Application.Selector,
            new Map<SObjectType, Type> {
                Factura__c.SObjectType => Facturas.Constructor.class,
                Producto_de_Factura__c.SObjectType => ProductosDeFactura.Constructor.class,
                Order.SObjectType => Orders.Constructor.class,
                Account.SObjectType => Accounts.Constructor.class,
                Error_Log__c.SObjectType => ErrorLog.Constructor.class
            }
        );
}