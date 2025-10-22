import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../shared/widgets/section_header_widget.dart';
import '../provider/plant_request_provider.dart';
import 'widgets/request_summary_card.dart';
import 'widgets/plant_request_card.dart';
import 'create_plant_request_screen.dart';

class DistributorRequestDashboard extends StatefulWidget {
  const DistributorRequestDashboard({super.key});

  @override
  State<DistributorRequestDashboard> createState() =>
      _DistributorRequestDashboardState();
}

class _DistributorRequestDashboardState
    extends State<DistributorRequestDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlantRequestProvider>().fetchRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Notifications',
        showBackButton: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreatePlantRequestScreen(),
            ),
          ).then((_) {
            // Refresh requests after creating new one
            context.read<PlantRequestProvider>().fetchRequests();
          });
        },
        backgroundColor: const Color(0xFF1A2B4C),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Request Cylinders',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Consumer<PlantRequestProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.requests.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchRequests(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Section
                  _buildSummarySection(provider),
                  const SizedBox(height: 24),

                  // Pending Requests Section
                  _buildPendingRequestsSection(provider),
                  const SizedBox(height: 24),

                  // Approved Requests Section
                  _buildApprovedRequestsSection(provider),
                  const SizedBox(height: 24),

                  // Recent Requests Section
                  _buildRecentRequestsSection(provider),
                  const SizedBox(height: 80), // Space for FAB
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummarySection(PlantRequestProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeaderWidget(title: 'Request Summary'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: RequestSummaryCard(
                title: 'Pending',
                value: provider.pendingRequests.length.toString(),
                icon: Icons.pending_actions,
                backgroundColor: const Color(0xFFFFF3E0),
                iconColor: const Color(0xFFFF9800),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RequestSummaryCard(
                title: 'Approved',
                value: provider.approvedRequests.length.toString(),
                icon: Icons.check_circle,
                backgroundColor: const Color(0xFFE8F5E9),
                iconColor: const Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RequestSummaryCard(
                title: 'Completed',
                value: provider.completedRequests.length.toString(),
                icon: Icons.done_all,
                backgroundColor: const Color(0xFFE3F2FD),
                iconColor: const Color(0xFF1A2B4C),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPendingRequestsSection(PlantRequestProvider provider) {
    final pendingRequests = provider.pendingRequests;

    if (pendingRequests.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'Pending Requests',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9800),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    pendingRequests.length.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...pendingRequests.map(
          (request) => PlantRequestCard(
            request: request,
            onTap: () {
              // TODO: Navigate to request details
            },
          ),
        ),
      ],
    );
  }

  Widget _buildApprovedRequestsSection(PlantRequestProvider provider) {
    final approvedRequests = provider.approvedRequests;

    if (approvedRequests.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'Approved Requests',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    approvedRequests.length.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...approvedRequests.map(
          (request) => PlantRequestCard(
            request: request,
            onTap: () {
              // TODO: Navigate to request details
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentRequestsSection(PlantRequestProvider provider) {
    final recentRequests = provider.requests.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeaderWidget(title: 'Recent Requests'),
        const SizedBox(height: 16),
        if (recentRequests.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No requests yet',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the button below to request cylinders',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          ...recentRequests.map(
            (request) => PlantRequestCard(
              request: request,
              onTap: () {
                // TODO: Navigate to request details
              },
            ),
          ),
      ],
    );
  }
}
