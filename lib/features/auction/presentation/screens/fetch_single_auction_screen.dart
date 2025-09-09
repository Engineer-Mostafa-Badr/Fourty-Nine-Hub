import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/base_status_enum.dart';
import '../../../../service_locator/service_locator.dart';
import '../../domain/entities/get_all_auction_entity.dart';
import '../cubit/auction_cubit.dart';

class SingleAuctionScreen extends StatefulWidget {
  final String auctionId;

  const SingleAuctionScreen({super.key, required this.auctionId});

  @override
  State<SingleAuctionScreen> createState() => _SingleAuctionScreenState();
}

class _SingleAuctionScreenState extends State<SingleAuctionScreen> {
  final TextEditingController _bidController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<AuctionCubit>();

    cubit.getSingleAuction(widget.auctionId);
    cubit.joinAuction(widget.auctionId);
    cubit.loadInitialParticipants(widget.auctionId);
    cubit.listenToNewBids(); // 👈 start listening to socket bids
  }


  @override
  void dispose() {
    _bidController.dispose();
    super.dispose();
  }

  void _placeBid(BuildContext context, String auctionId) {
    final bidAmount = int.tryParse(_bidController.text);
    if (bidAmount == null || bidAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid amount")),
      );
      return;
    }

    context.read<AuctionCubit>().sendBid(auctionId, bidAmount);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Bid placed: \$${bidAmount.toString()}")),
    );

    _bidController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Auction Details")),
      body: BlocBuilder<AuctionCubit, AuctionState>(
        builder: (context, state) {
          if (state.status == StateStatus.loading &&
              state.singleAuction == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == StateStatus.error &&
              state.singleAuction == null) {
            return const Center(
              child: Text("Error loading auction",
                  style: TextStyle(color: Colors.red)),
            );
          }

          final auction = state.singleAuction;
          if (auction == null) {
            return const Center(child: Text("Auction not found"));
          }

          return Column(
            children: [
              // Top half: auction details
              Expanded(child: _AuctionDetails(auction: auction)),

              // Middle half: participants list
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                child: _ParticipantsList(auctionId: widget.auctionId),
              ),

              // Bottom: bid input
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _bidController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter your bid",
                          prefixIcon: const Icon(Icons.attach_money),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => _placeBid(context, widget.auctionId),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Place Bid"),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}



class _AuctionDetails extends StatelessWidget {
  final GetAvailableAuctionEntity auction;

  const _AuctionDetails({required this.auction});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (auction.media?.isNotEmpty == true)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              auction.media!.first.mediaKey ?? "",
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
              const SizedBox(height: 200, child: Icon(Icons.image)),
            ),
          ),
        const SizedBox(height: 16),
        Text(
          auction.title ?? "No Title",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(auction.description ?? ""),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              "Current Price: \$${auction.currentPrice ?? 0}",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Text(
              auction.status ?? "",
              style: TextStyle(
                color: auction.status == "pending"
                    ? Colors.orange
                    : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          "Start: ${auction.startAt?.toLocal().toString().substring(0, 16) ??
              "-"}",
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        Text(
          "End: ${auction.endAt?.toLocal().toString().substring(0, 16) ?? "-"}",
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}
class _ParticipantsList extends StatefulWidget {
  final String auctionId;

  const _ParticipantsList({super.key, required this.auctionId});

  @override
  State<_ParticipantsList> createState() => _ParticipantsListState();
}

class _ParticipantsListState extends State<_ParticipantsList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<AuctionCubit>();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        cubit.getParticipants(widget.auctionId); // 👈 fetch more
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuctionCubit, AuctionState>(
      builder: (context, state) {
        final participants = state.auctionParticipants ?? [];

        if (participants.isEmpty && state.status == StateStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          controller: _scrollController,
          itemCount: participants.length + 1,
          itemBuilder: (context, index) {
            if (index == participants.length) {
              final cubit = context.read<AuctionCubit>();
              return cubit.hasMoreParticipants
                  ? const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              )
                  : const SizedBox.shrink();
            }

            final p = participants[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: p.profilePicture != null
                    ? NetworkImage(p.profilePicture!)
                    : null,
                child: p.profilePicture == null
                    ? Text(p.username?[0].toUpperCase() ?? "?")
                    : null,
              ),
              title: Text(p.username ?? "Unknown"),
              subtitle: Text("Bid: \$${p.newPrice ?? 0}"),
              trailing: Text(
                p.createdAt?.toLocal().toString().substring(0, 16) ?? "",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            );
          },
        );
      },
    );
  }
}
